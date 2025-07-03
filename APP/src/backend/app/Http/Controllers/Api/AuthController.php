<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\AuthService;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    private $authService;

    public function __construct(AuthService $authService)
    {
        $this->authService = $authService;
    }

    public function login(Request $request)
    {
        // デバッグログ
        Log::info('Login attempt', [
            'email' => $request->email,
            'has_password' => !empty($request->password),
            'request_data' => $request->all()
        ]);

        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        // レート制限をチェック
        $this->ensureIsNotRateLimited($request);

        try {
            $result = $this->authService->login(
                $request->email,
                $request->password
            );

            // 成功時はレート制限をクリア
            RateLimiter::clear($this->throttleKey($request));

            Log::info('Login successful', ['email' => $request->email]);

            return response()->json(
                $result,
                200,
                ['Content-Type' => 'application/json; charset=UTF-8'],
                JSON_UNESCAPED_UNICODE
            );
        } catch (ValidationException $e) {
            // 失敗時はレート制限を記録
            RateLimiter::hit($this->throttleKey($request));
            
            Log::error('Login validation failed', [
                'email' => $request->email,
                'errors' => $e->errors()
            ]);
            
            throw $e;
        } catch (\Exception $e) {
            Log::error('Login error', [
                'email' => $request->email,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            throw $e;
        }
    }

    public function logout(Request $request)
    {
        $user = $request->user();
        $this->authService->logout($user);
        
        return response()->json(
            ['message' => 'ログアウトしました'],
            200,
            ['Content-Type' => 'application/json; charset=UTF-8'],
            JSON_UNESCAPED_UNICODE
        );
    }

    // 統合登録API
    public function register(Request $request)
    {
        try {
            $validator = \Illuminate\Support\Facades\Validator::make($request->all(), [
                'name' => 'required|string|max:100',
                'gender' => 'required|string|max:10',
                'barth_day' => 'required|date',
                'phone_number' => 'required|string|max:20',
                'email' => 'required|email|unique:user_passes,email',
                'password' => 'required|string|min:8',
                'postal_code' => 'nullable|string|max:8',
                'prefecture' => 'nullable|string|max:10',
                'city' => 'nullable|string|max:50',
                'address_line1' => 'nullable|string|max:100',
                'address_line2' => 'nullable|string|max:100',
            ]);

            if ($validator->fails()) {
                return response()->json(
                    ['errors' => $validator->errors()],
                    422,
                    ['Content-Type' => 'application/json; charset=UTF-8'],
                    JSON_UNESCAPED_UNICODE
                );
            }

            $result = $this->authService->register($request->all());
            
            return response()->json(
                [
                    'message' => '会員登録が完了しました',
                    'user_id' => $result['user_id']
                ],
                201,
                ['Content-Type' => 'application/json; charset=UTF-8'],
                JSON_UNESCAPED_UNICODE
            );
        } catch (\Exception $e) {
            \Illuminate\Support\Facades\Log::error('Registration error', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json(
                ['error' => '会員登録に失敗しました: ' . $e->getMessage()],
                500,
                ['Content-Type' => 'application/json; charset=UTF-8'],
                JSON_UNESCAPED_UNICODE
            );
        }
    }

    /**
     * レート制限をチェック
     */
    private function ensureIsNotRateLimited(Request $request): void
    {
        if (!RateLimiter::tooManyAttempts($this->throttleKey($request), 5)) {
            return;
        }

        $seconds = RateLimiter::availableIn($this->throttleKey($request));

        throw ValidationException::withMessages([
            'email' => [trans('auth.throttle', [
                'seconds' => $seconds,
                'minutes' => ceil($seconds / 60),
            ])],
        ]);
    }

    /**
     * レート制限のキーを取得
     */
    private function throttleKey(Request $request): string
    {
        return Str::transliterate(Str::lower($request->input('email')).'|'.$request->ip());
    }
} 