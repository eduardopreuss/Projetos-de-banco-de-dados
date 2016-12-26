<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body>
        
        <?php
        
        include_once("./operacoes.php");
        $operacoes = new Operacoes();
        
        //nao sei se fazia parte do exercicio ou nao mas a tabela produtos_cores veio com erros nas chaves estrageiras. Nesse funcao esse erro é consertado. Tambem foi inserido auto_incremente nas colunas 'id' pois foi usado MySql para realizar a atividade
        $operacoes->mudaTabela('SET FOREIGN_KEY_CHECKS = 0;
            ALTER TABLE produtos modify id int(11) auto_increment;
ALTER TABLE produtos_cores modify id int(11) auto_increment;
ALTER TABLE produtos_tamanhos modify id int(11) auto_increment;
ALTER TABLE cores modify id int(11) auto_increment;
ALTER TABLE tamanhos modify id int(11) auto_increment;
ALTER TABLE produtos_cores DROP FOREIGN KEY produtos_cores_ibfk_1;
ALTER TABLE produtos_cores DROP FOREIGN KEY produtos_cores_ibfk_2;
ALTER TABLE produtos_cores ADD FOREIGN KEY(id_cor) REFERENCES cores (id);
ALTER TABLE produtos_cores ADD FOREIGN KEY(id_produto) REFERENCES produtos (id);
SET FOREIGN_KEY_CHECKS = 1;
');       
        //inserindo dados na tabela produtos
        $selectSql= 'select titulo,codigo from dados_antigos group by titulo,codigo;';
        $busca = $operacoes->getValores($selectSql);
        $colunasOrigem = array('titulo', 'codigo');
       $operacoes->set($busca,'insert into produtos (titulo,id,codigo) values (:info1,default,:info2)',$colunasOrigem);           
        //inserindo dados na tabela cores
        $selectSql= 'select cor from dados_antigos group by cor;';
        $busca = $operacoes->getValores($selectSql);
        $colunasOrigem = array('cor');
        $operacoes->set($busca,'insert into cores (id,titulo) values (default,:info1)',$colunasOrigem);
         
        //inserindo dados na tabela cores tamanhos
        $selectSql= 'select tamanho from dados_antigos group by tamanho;';
        $busca = $operacoes->getValores($selectSql);
        $colunasOrigem = array('tamanho');
        $operacoes->set($busca,'insert into tamanhos (id,titulo) values (default,:info1)',$colunasOrigem);
        
        //inserindo dados na tabela cores produtos_cores
        $selectSql = 'select c.id c_id, p.id p_id from dados_antigos da join produtos p on da.titulo = p.titulo join cores c on da.cor = c.titulo group by c_id,p_id;';        
        $busca = $operacoes->getValores($selectSql);
        $colunasOrigem = array('c_id','p_id');
        $operacoes->set($busca,'insert into produtos_cores (id_cor,id_produto,id) values (:info1,:info2,default)',$colunasOrigem);
     
        //inserindo dados na tabela cores produtos_tamanhos
        $selectSql = 'select t.id t_id, pc.id pc_id from dados_antigos da join tamanhos t on da.tamanho = t.titulo join cores c on da.cor = c.titulo join produtos_cores pc on pc.id_cor = c.id  group by t_id,pc_id;';        
        $busca = $operacoes->getValores($selectSql);
        $colunasOrigem = array('t_id','pc_id');
        $operacoes->set($busca,'insert into produtos_tamanhos (id_tamanho,id_produto_cor,id) values (:info1,:info2,default)',$colunasOrigem);
        
        echo 'Migração de banco de dados realizada com sucesso!';
        
        ?>
    </body>
</html>
