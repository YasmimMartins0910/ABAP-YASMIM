*&---------------------------------------------------------------------*
*& Include          ZR_HEADER_ITEM_ALV_YAS_TOP
*&---------------------------------------------------------------------*
TABLES: ztb_c100_yas, ztb_c170_yas.

CONSTANTS: gc_div   TYPE STRING VALUE 'DIVERGENTE',
           gc_erro1 TYPE STRING VALUE 'Header e item correspondem, porém a diferença ultrapassa a tolerância informada.',
           gc_cas   TYPE STRING VALUE 'CASADO',
           gc_erro2 TYPE STRING VALUE 'Header e itens correspondem dentro dos limites',
           gc_h_s_i TYPE STRING VALUE 'HEADER_SEM_ITEM',
           gc_erro3 TYPE STRING VALUE 'Header registrado sem itens',
           gc_erro4 TYPE STRING VALUE 'Valor do header difere da soma dos itens',
           gc_erro5 TYPE STRING VALUE 'Header e itens correspondem dentro da tolerância',
           gc_i_s_h TYPE STRING VALUE 'ITEM_SEM_HEADER',
           gc_erro6 TYPE STRING VALUE 'Produto registrado sem header associado.'.

DATA: go_salv_tab TYPE REF TO cl_salv_table. "classe da criação do ALV

DATA: gt_header     TYPE TABLE OF ztb_c100_yas,
      gt_itens      TYPE TABLE OF ztb_c170_yas,
      gt_alvheader  TYPE TABLE OF zst_alv_c100_yas,
      gt_alvitens   TYPE TABLE OF zst_alv_c170_yas.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001. "RELATÓRIO
  PARAMETERS: p_res   RADIOBUTTON GROUP g1 DEFAULT 'X',
              p_compl RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002. "FILTROS
  PARAMETERS: p_todos  RADIOBUTTON GROUP g2 DEFAULT 'X',
              p_csd    RADIOBUTTON GROUP g2,
              p_div    RADIOBUTTON GROUP g2,
              p_semrel RADIOBUTTON GROUP g2.
  PARAMETERS: p_tol TYPE p DECIMALS 2 DEFAULT '500.00'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECT-OPTIONS: s_numdoc FOR ztb_c100_yas-num_doc,
                  s_data   FOR ztb_c100_yas-dt_doc,
                  s_parc   FOR ztb_c100_yas-cod_part,
                  s_mdoc   FOR ztb_c100_yas-cod_mod,
                  s_sit    FOR ztb_c100_yas-cod_sit.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-004.
  SELECT-OPTIONS: s_cfop  FOR ztb_c170_yas-cfop,
                  s_numit FOR ztb_c170_yas-num_item,
                  s_cstic FOR ztb_c170_yas-cst_icms.
SELECTION-SCREEN END OF BLOCK b4.
