<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of operacoes
 *
 * @author eduardo-pc
 */
class operacoes {

    public function conexao() {

        try {
            $pdo = new PDO('mysql:host=localhost;dbname=teste_selecao;charset=utf8', 'root', '');
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            return $pdo;
        } catch (Exception $e) {
            echo 'erro na conexão com o banco de dados: ' . $e;
        }
    }

    public function mudaTabela($prepare) {
        $pdo = $this->conexao();
        try {
            $set = $pdo->prepare($prepare);
            $set->execute();
        } catch (Execption $e) {
            echo 'Erro ao fazer mudanças nas tabelas' . $e;
        }
    }

    public function getValores($selectSql) {        
            $pdo = $this->conexao();
        try {
            $busca = $pdo->prepare($selectSql);
            $busca->execute();
            return $busca;
        } catch (Exception $e) {
            echo 'Erro ao buscar os dados nas tabelas: ' . $e;
        }
    }
    public function set($busca, $prepare, $dadosOrigem) {
        $pdo = $this->conexao();
        try{
        $set = $pdo->prepare($prepare);        
        while ($linha = $busca->fetch(PDO::FETCH_ASSOC)) {           
            $NumeroDeColunas = count($dadosOrigem);
            for ($f = 0; $f < $NumeroDeColunas; $f++) {
                $dOrigem[] = $linha[$dadosOrigem[$f]];  
            }
        }             
        $tabelas = 1;      
        for ($f = 0; $f < count($dOrigem); $f++) {
            $set->bindValue(':info'.$tabelas, $dOrigem[$f]);
            if ($tabelas == $NumeroDeColunas) {
                $tabelas = 1;
                $set->execute();
            } else 
                $tabelas++;                
        }
    } catch (Execption $e){
     echo 'Erro ao inserir os dados nas tabelas'.$e;
 }
    }

}
