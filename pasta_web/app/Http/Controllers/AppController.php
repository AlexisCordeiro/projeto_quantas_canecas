<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AppController extends Controller
{
    public function index()
    {
        return view('app');
    }

    public function getQuantidadeCanecas()
    {
        $mugQuantity = DB::table('mug_quantity')->value('quantity');
    
        return $mugQuantity;
    }

    public function setQuantidadeCanecas(Request $request)
    {
        $quantidadeCanecas = $request->input('quantidadeCanecas');

        // Salvar a quantidade de canecas no banco de dados ou executar outras ações necessárias
        DB::table('mug_quantity')->update(['quantity' => $quantidadeCanecas]);

        // Recuperar a quantidade atualizada do banco de dados
        $quantidadeAtualizada = DB::table('mug_quantity')->value('quantity');

        return response()->json([
            'success' => true,
            'quantidadeCanecas' => $quantidadeAtualizada,
        ]);
    }
}
