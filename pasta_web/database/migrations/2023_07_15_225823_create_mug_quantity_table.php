<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMugQuantityTable extends Migration
{
    public function up()
    {
        Schema::create('mug_quantity', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('quantity')->default(0);
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('mug_quantity');
    }
}
