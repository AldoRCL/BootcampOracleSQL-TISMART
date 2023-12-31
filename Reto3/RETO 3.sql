-----------------EJERCICIO 1----------------------
-- VISTA DE CLIENTES SIN PEDIDOS FACTURADOS
CREATE OR REPLACE VIEW CLIENTES_SIN_FACTURADOS
AS
SELECT c.*
FROM CLIENTES c
WHERE NOT EXISTS (
  SELECT 1
  FROM PEDIDOS p
  WHERE c.COD_CLIE = p.COD_CLIE
    AND p.FEC_FACT IS NOT NULL
);

SELECT * FROM CLIENTES_SIN_FACTURADOS;

-- VISTA DE PEDIDOS CON CLIENTES INEXISTENTES
CREATE OR REPLACE VIEW PEDIDOS_CLIENTES_INEXISTENTES
AS
SELECT p.*
FROM PEDIDOS p
WHERE NOT EXISTS (
  SELECT 1
  FROM CLIENTES c
  WHERE p.COD_CLIE = c.COD_CLIE
);

SELECT * FROM PEDIDOS_CLIENTES_INEXISTENTES;

-----------------EJERCICIO 2----------------------
CREATE OR REPLACE TRIGGER REEMPLAZAR_LETRA_N
BEFORE INSERT OR UPDATE ON CLIENTES
FOR EACH ROW
BEGIN
    :NEW.VAL_APE1 := UPPER(REPLACE(REPLACE(:NEW.VAL_APE1, '�', 'N'), '�', 'n'));
    :NEW.VAL_APE2 := UPPER(REPLACE(REPLACE(:NEW.VAL_APE2, '�', 'N'), '�', 'n'));
END;

UPDATE CLIENTES SET VAL_APE1 = 'Co�iTrA' WHERE COD_CLIE = 41316;
UPDATE CLIENTES SET VAL_APE2 = 'lO�AzO' WHERE COD_CLIE = 41316;

SELECT * FROM CLIENTES;

-----------------EJERCICIO 3----------------------

CREATE OR REPLACE FUNCTION CALCULAR_DEUDA_TOTAL(p_zona IN INTEGER)
RETURN FLOAT IS
  v_monto_deuda FLOAT := 0;
BEGIN
  SELECT SUM(SAL_DEUD_ANTE)
  INTO v_monto_deuda
  FROM PEDIDOS
  WHERE COD_ZONA = p_zona;
  
  RETURN v_monto_deuda;
END;

----LLAMAR A LA FUNCION CALCULAR_DEUDA_TOTAL----
DECLARE
  v_deuda_total FLOAT;
BEGIN
  v_deuda_total := CALCULAR_DEUDA_TOTAL(1729); -- PASAR EL VALOR DE LA ZONA
  DBMS_OUTPUT.PUT_LINE('Monto de Deuda Total: ' || v_deuda_total);
END;
