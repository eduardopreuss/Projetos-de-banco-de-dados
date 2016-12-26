--criei as tabelas com o "2" na frente para evitar conflitos de tabelas com o mesmo nome
CREATE TABLE departamento2
  (
    id_departamento2 INT,
    nome             VARCHAR2(100),
    CONSTRAINT pk_id_departamento2 PRIMARY KEY (id_departamento2)
  );
CREATE TABLE produto2
  (
    id_produto2      INT,
    id_departamento2 INT,
    nome             VARCHAR2(100),
    preco FLOAT,
    quantidade_estoque NUMBER(6),
    CONSTRAINT pk_id_produto2 PRIMARY KEY (id_produto2),
    CONSTRAINT fk_id_departamento2 FOREIGN KEY (id_departamento2) REFERENCES departamento2(id_departamento2)
  );
CREATE TABLE funcionario2
  (
    id_funcionario2  INT,
    id_departamento2 INT,
    nome             VARCHAR2(100),
    nascimento       DATE,
    data_contratacao DATE,
    salario_fixo FLOAT,
    comissao FLOAT,
    cargo VARCHAR2(100),
    CONSTRAINT pk_id_funcionario2 PRIMARY KEY (id_funcionario2),
    CONSTRAINT fk_id_departamento2_func FOREIGN KEY (id_departamento2) REFERENCES departamento2(id_departamento2)
  );
CREATE TABLE venda2
  (
    id_venda2          INT,
    id_produto2        INT,
    id_funcionario2    INT,
    forma_pagamento    VARCHAR2(100),
    data               DATE,
    quantidade_vendida NUMBER(6),
    CONSTRAINT pk_id_venda2 PRIMARY KEY (id_venda2),
    CONSTRAINT fk_id_produto2 FOREIGN KEY (id_produto2) REFERENCES produto2( id_produto2),
    CONSTRAINT fk_id_funcionario2 FOREIGN KEY (id_funcionario2) REFERENCES funcionario2(id_funcionario2)
  );
CREATE SEQUENCE Svenda2 NOCACHE;
CREATE SEQUENCE Sdepartamento2 NOCACHE;
CREATE SEQUENCE Sfuncionario2 NOCACHE;
CREATE SEQUENCE Sproduto2 NOCACHE;
  INSERT
  INTO departamento2
    (
      id_departamento2,
      nome
    )
    VALUES
    (
      Sdepartamento2.nextval,
      'Bebidas'
    );
  INSERT
  INTO produto2
    (
      id_produto2,
      id_departamento2,
      nome,
      preco,
      quantidade_estoque
    )
    VALUES
    (
      Sproduto2.nextval,
      3,
      'Agua',
      5.0,
      6
    );
  INSERT
  INTO funcionario2
    (
      id_funcionario2,
      id_departamento2,
      nome,
      nascimento,
      data_contratacao,
      salario_fixo,
      comissao,
      cargo
    )
    VALUES
    (
      Sfuncionario2.nextval,
      1,
      'Gabriel',
      TO_DATE('1993/05/03', 'yyyy/mm/dd'),
      TO_DATE('2007/05/03', 'yyyy/mm/dd'),
      1505.95,
      0.05,
      'Atendente'
    );
  INSERT
  INTO venda2
    (
      id_venda2,
      id_produto2,
      id_funcionario2,
      forma_pagamento,
      data,
      quantidade_vendida
    )
    VALUES
    (
      Svenda2.nextval,
      3,5,
      'Cartao',
      sysdate,
      1
    );
CREATE OR REPLACE TRIGGER verifica_contr_nasc BEFORE
  INSERT OR
  UPDATE OF id_funcionario2,
    data_contratacao,
    nascimento ON funcionario2 FOR EACH ROW DECLARE v_nasc DATE;
  v_contr                                                  DATE;
  PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    SELECT nascimento,
      data_contratacao
    INTO v_nasc,
      v_contr
    FROM funcionario2
    WHERE id_funcionario2 = :new.id_funcionario2;
    IF (:new.nascimento   > v_contr OR v_nasc > :new.data_contratacao) THEN
      raise_application_error (-20900, 'A data de nascimento não pode ser mais recente que a data de contratação' );
    END IF;
  EXCEPTION
  WHEN no_data_found THEN
    NULL;
  END;
  /
  SHOW ERRORS;
CREATE OR REPLACE TRIGGER verifica_quantidade BEFORE
  INSERT OR
  UPDATE OF quantidade_vendida ON venda2 FOR EACH ROW DECLARE v_qe NUMBER;
  BEGIN
    SELECT quantidade_estoque
    INTO v_qe
    FROM produto2
    WHERE :new.id_produto2      = id_produto2;
    IF (:new.quantidade_vendida > v_qe) THEN
      raise_application_error (-20911, 'Não há disponibilidade deseja deste produto em estoque');
    ELSE
      UPDATE produto2
      SET quantidade_estoque =((quantidade_estoque + :old.quantidade_vendida) - :new.quantidade_vendida)
      WHERE :new.id_produto2 = id_produto2;
    END IF;
  END;
  /
  SHOW ERRORS;
CREATE OR REPLACE
PROCEDURE soma_salario(
    p_data_inicio IN DATE,
    p_data_fim    IN DATE,
    p_nome_func   IN funcionario2.nome%type,
    p_comissao OUT funcionario2.comissao%type,
    p_salario_total OUT FLOAT)
IS
  v_total FLOAT;
  v_sal_fixo FLOAT;
  v_comissao FLOAT;
BEGIN
  SELECT f2.salario_fixo,
    f2.comissao,
    SUM(p2.preco * v2.quantidade_vendida)
  INTO v_sal_fixo,
    v_comissao,
    v_total
  FROM funcionario2 f2
  JOIN venda2 v2
  ON f2.id_funcionario2 = v2.id_funcionario2
  JOIN produto2 p2
  ON p2.id_produto2 = v2.id_produto2
  WHERE f2.nome     = p_nome_func
  AND v2.data BETWEEN p_data_inicio AND p_data_fim
  GROUP BY f2.salario_fixo,
    f2.comissao;
  p_comissao      := v_total    * v_comissao;
  p_salario_total := p_comissao + v_sal_fixo;
EXCEPTION
WHEN no_data_found THEN
  raise_application_error(-20001,'Não houve vendas deste funcionário nesse periodo ' );
END;
/
SHOW ERRORS;
var v1 NUMBER;
var v2 NUMBER;
EXEC soma_salario(to_date('1800/05/03', 'yyyy/mm/dd'), to_date('2030/05/03', 'yyyy/mm/dd'), 'rafael',:v1,:v2);
PRINT v1;
PRINT v2;
CREATE OR REPLACE
PROCEDURE funcionario_vendas(
    p_data_inicio IN venda2.data%type,
    p_data_fim    IN venda2.data%type,
    p_nome_func   IN funcionario2.nome%type)
IS
  CURSOR c_vendas
  IS
    SELECT p2.nome,
      p2.preco,
      v2.quantidade_vendida,
      v2.data
    FROM venda2 v2
    JOIN produto2 p2
    ON p2.id_produto2 = v2.id_produto2
    JOIN funcionario2 f2
    ON f2.id_funcionario2 = v2.id_funcionario2
    WHERE f2.nome         = p_nome_func
    AND v2.data BETWEEN p_data_inicio AND p_data_fim;
BEGIN
  FOR r_vendas IN c_vendas
  LOOP
    DBMS_OUTPUT.PUT_LINE(r_vendas.nome);
    DBMS_OUTPUT.PUT_LINE(r_vendas.preco);
    DBMS_OUTPUT.PUT_LINE(r_vendas.quantidade_vendida);
    DBMS_OUTPUT.PUT_LINE(r_vendas.data);
  END LOOP;
END;
/
SET serveroutput ON;
EXEC funcionario_vendas(to_date('1800/05/03', 'yyyy/mm/dd'), to_date('2030/05/03', 'yyyy/mm/dd'), 'rafael');
CREATE OR REPLACE
  FUNCTION bens_departamento(
      p_nome_departamento IN VARCHAR2)
    RETURN NUMBER
  IS
    v_count NUMBER;
  BEGIN
    SELECT SUM(p2.quantidade_estoque * p2.preco)
    INTO v_count
    FROM produto2 p2
    JOIN departamento2 d2
    ON d2.id_departamento2 = p2.id_departamento2
    WHERE d2.nome          = p_nome_departamento;
    RETURN v_count;
  END;
  /
  show errors;
  var v_count NUMBER;
  EXEC :v_count := bens_departamento('eletronicos');
  PRINT v_count;
CREATE OR REPLACE
FUNCTION vendas_por_pagamento(
    p_forma_pagamento IN venda2.forma_pagamento%type)
  RETURN NUMBER
IS
  CURSOR c_pagamento
  IS
    SELECT p2.nome,
      p2.preco,
      v2.quantidade_vendida,
      v2.data,
      v2.forma_pagamento
    FROM venda2 v2
    JOIN produto2 p2
    ON p2.id_produto2        = v2.id_produto2
    WHERE v2.forma_pagamento = p_forma_pagamento;
  r_pagamento c_pagamento%ROWTYPE;
BEGIN
  OPEN c_pagamento;
  LOOP
    FETCH c_pagamento INTO r_pagamento;
    IF c_pagamento%NOTFOUND THEN
      EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE(r_pagamento.nome);
    DBMS_OUTPUT.PUT_LINE(r_pagamento.preco);
    DBMS_OUTPUT.PUT_LINE(r_pagamento.quantidade_vendida);
    DBMS_OUTPUT.PUT_LINE(r_pagamento.data);
    DBMS_OUTPUT.PUT_LINE(r_pagamento.forma_pagamento);
  END LOOP;
  CLOSE c_pagamento;
  RETURN 0;
END;
/
show errors;
VARIABLE v NUMBER;
EXEC :v := vendas_por_pagamento('Dinheiro');
CREATE OR REPLACE
PROCEDURE mais_vendido(
    p_data_inicio IN venda2.data%type,
    p_data_fim    IN venda2.data%type,
    p_nome_dep    IN departamento2.nome%type,
    p_nome_prod OUT VARCHAR2,
    p_quantidade OUT NUMBER)
IS
  CURSOR c_vendido
  IS
    SELECT p2.nome,
      v2.quantidade_vendida
    FROM departamento2 d2
    JOIN produto2 p2
    ON p2.id_departamento2 = d2.id_departamento2
    JOIN venda2 v2
    ON v2.id_venda2 = v2.id_venda2
    WHERE d2.nome   = p_nome_dep
    AND v2.data BETWEEN p_data_inicio AND p_data_fim;
BEGIN
  p_quantidade := 0;
  FOR r_vendas IN c_vendido
  LOOP
    p_quantidade := p_quantidade + r_vendas.quantidade_vendida;
    p_nome_prod  := r_vendas.nome;
  END LOOP;
END;
/
var qt NUMBER;
var nm VARCHAR2(50);
EXEC mais_vendido (to_date('1800/05/03', 'yyyy/mm/dd'), to_date('2030/05/03', 'yyyy/mm/dd'),'eletronicos',:nm,:qt);
PRINT qt;
PRINT nm;