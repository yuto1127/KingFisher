<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('entry_statuses', function (Blueprint $table) {
            // 外部キー制約が存在する場合のみ削除
            if (Schema::hasColumn('entry_statuses', 'event_id')) {
                // 外部キー制約を削除（存在する場合のみ）
                try {
                    $table->dropForeign(['event_id']);
                } catch (Exception $e) {
                    // 外部キー制約が存在しない場合は無視
                }
                
                // ユニーク制約を削除（存在する場合のみ）
                try {
                    $table->dropUnique(['event_id', 'user_id']);
                } catch (Exception $e) {
                    // ユニーク制約が存在しない場合は無視
                }
                
                // event_idカラムを削除
                $table->dropColumn('event_id');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('entry_statuses', function (Blueprint $table) {
            // event_idカラムが存在しない場合のみ追加
            if (!Schema::hasColumn('entry_statuses', 'event_id')) {
                // event_idカラムを追加
                $table->unsignedBigInteger('event_id')->after('id');
                
                // 外部キー制約を追加
                $table->foreign('event_id')
                    ->references('id')
                    ->on('events')
                    ->onDelete('restrict')
                    ->onUpdate('cascade');
                
                // ユニーク制約を追加
                $table->unique(['event_id', 'user_id']);
            }
        });
    }
};
