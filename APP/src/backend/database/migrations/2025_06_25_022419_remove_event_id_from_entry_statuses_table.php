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
            // 外部キー制約を削除
            $table->dropForeign(['event_id']);
            
            // ユニーク制約を削除（event_idとuser_idの組み合わせ）
            $table->dropUnique(['event_id', 'user_id']);
            
            // event_idカラムを削除
            $table->dropColumn('event_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('entry_statuses', function (Blueprint $table) {
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
        });
    }
};
