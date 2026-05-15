*&---------------------------------------------------------------------*
*& Include          ZR_HEADER_ITEM_ALV_YAS_F01
*&---------------------------------------------------------------------*
FORM get_dados.

  SELECT *
    FROM ztb_c100_yas
    INTO TABLE gt_header
    WHERE num_doc IN s_numdoc
    AND dt_doc IN s_data
    AND cod_part IN s_parc
    AND cod_mod IN s_mdoc
    AND cod_sit IN s_sit.

  SELECT *
    FROM ztb_c170_yas
    INTO TABLE gt_itens
    WHERE num_doc IN s_numdoc
      AND cfop IN s_cfop
      AND num_item IN s_numit
      AND cst_icms IN s_cstic.

ENDFORM.

FORM display_alv USING p_alv_table TYPE ANY TABLE.

  CALL METHOD cl_salv_table=>factory
*    EXPORTING
*      list_display   = if_salv_c_bool_sap=>false " ALV Displayed in List Mode
*      r_container    =                           " Abstract Container for GUI Controls
*      container_name =
    IMPORTING
      r_salv_table = go_salv_tab                       " Basis Class Simple ALV Tables
    CHANGING
      t_table      = p_alv_table.
*  CATCH cx_salv_msg. " ALV: General Error Class with Message

  IF go_salv_tab IS BOUND.

    go_salv_tab->display( ).

  ENDIF.

ENDFORM.

FORM cross_data.

  DATA: ls_header      TYPE ztb_c100_yas,
        ls_itens       TYPE ztb_c170_yas,
        ls_itens_aux   TYPE ztb_c170_yas,
        ls_alv_c100    TYPE zst_alv_c100_yas,
        ls_alv_c170    TYPE zst_alv_c170_yas.

  DATA: lv_soma_itens  TYPE p DECIMALS 2,
        lv_diferenca   TYPE p DECIMALS 2.

  SORT gt_header BY num_doc.
  SORT gt_itens  BY num_doc num_item.

  IF p_res = abap_true.

    LOOP AT gt_header INTO ls_header.
      CLEAR ls_alv_c100.

      ls_alv_c100-num_doc    = ls_header-num_doc.
      ls_alv_c100-dt_doc     = ls_header-dt_doc.
      ls_alv_c100-cod_part   = ls_header-cod_part.
      ls_alv_c100-cod_mod    = ls_header-cod_mod.
      ls_alv_c100-cod_sit    = ls_header-cod_sit.
      ls_alv_c100-vl_total   = ls_header-vl_doc.

      READ TABLE gt_itens TRANSPORTING NO FIELDS
        WITH KEY num_doc = ls_header-num_doc
        BINARY SEARCH.

      IF sy-subrc = 0.

        CLEAR lv_soma_itens.

        LOOP AT gt_itens INTO ls_itens WHERE num_doc = ls_header-num_doc.

          ls_alv_c100-quant = ls_alv_c100-quant + 1.
          lv_soma_itens = lv_soma_itens + ls_itens-vl_item.

        ENDLOOP.

        ls_alv_c100-soma_it = lv_soma_itens.

        lv_diferenca = ls_header-vl_doc - lv_soma_itens.

        IF lv_diferenca < 0.
          lv_diferenca = lv_diferenca * -1.
        ENDIF.

        ls_alv_c100-dif_calc = lv_diferenca.

        IF lv_diferenca > p_tol.
          ls_alv_c100-status_rel = gc_div.
          ls_alv_c100-obs        = gc_erro1.
        ELSE.
          ls_alv_c100-status_rel = gc_cas.
          ls_alv_c100-obs        = gc_erro2.
        ENDIF.

      ELSE.

        ls_alv_c100-quant      = 0.
        ls_alv_c100-soma_it    = 0.
        ls_alv_c100-dif_calc   = ls_header-vl_doc.
        ls_alv_c100-status_rel = gc_h_s_i.
        ls_alv_c100-obs        = gc_erro3.

      ENDIF.

      APPEND ls_alv_c100 TO gt_alvheader.
    ENDLOOP.

  ELSE. "relatório detalhado.

    LOOP AT gt_itens INTO ls_itens.
      CLEAR ls_alv_c170.

      ls_alv_c170-num_doc      = ls_itens-num_doc.
      ls_alv_c170-cfop         = ls_itens-cfop.
      ls_alv_c170-num_item     = ls_itens-num_item.
      ls_alv_c170-cst_icms     = ls_itens-cst_icms.
      ls_alv_c170-descr_compl  = ls_itens-descr_co_mpl.
      ls_alv_c170-quant        = ls_itens-qtd.
      ls_alv_c170-unidade      = ls_itens-unid.
      ls_alv_c170-vl_item      = ls_itens-vl_item.

      READ TABLE gt_header INTO ls_header
        WITH KEY num_doc = ls_itens-num_doc BINARY SEARCH.

      IF sy-subrc = 0.

        ls_alv_c170-vl_header = ls_header-vl_doc.
        ls_alv_c170-dt_doc    = ls_header-dt_doc.
        ls_alv_c170-cod_part  = ls_header-cod_part.
        ls_alv_c170-cod_mod   = ls_header-cod_mod.
        ls_alv_c170-cod_sit   = ls_header-cod_sit.

        CLEAR lv_soma_itens.

        LOOP AT gt_itens INTO ls_itens_aux WHERE num_doc = ls_header-num_doc.
          lv_soma_itens = lv_soma_itens + ls_itens_aux-vl_item.
        ENDLOOP.

        lv_diferenca = ls_header-vl_doc - lv_soma_itens.
        IF lv_diferenca < 0.
          lv_diferenca = lv_diferenca * -1.
        ENDIF.

        ls_alv_c170-soma_it = lv_soma_itens.
        ls_alv_c170-dif_calc = lv_diferenca.

        IF lv_diferenca > p_tol.
          ls_alv_c170-status_rel = gc_div.
          ls_alv_c170-obs = gc_erro4.
        ELSE.
          ls_alv_c170-status_rel = gc_cas.
          ls_alv_c170-obs =  gc_erro5.
        ENDIF.

      ELSE.

        ls_alv_c170-soma_it    = ls_itens-vl_item.
        ls_alv_c170-dif_calc   = ls_itens-vl_item.
        ls_alv_c170-status_rel = gc_i_s_h.
        ls_alv_c170-obs        = gc_erro6.
      ENDIF.

      APPEND ls_alv_c170 TO gt_alvitens.
    ENDLOOP.
  ENDIF.

ENDFORM.

FORM options.
*p_todos
*p_csd
*p_div
*p_semrel

  IF p_todos = abap_true.
    RETURN.
  ENDIF.

  IF p_res = abap_true.
    IF p_csd = abap_true.
      DELETE gt_alvheader WHERE status_rel <> 'CASADO'.
    ELSEIF p_div = abap_true.
      DELETE gt_alvheader WHERE status_rel <> 'DIVERGENTE'.
    ELSEIF p_semrel = abap_true.
      DELETE gt_alvheader WHERE status_rel <> 'HEADER_SEM_ITEM'
      AND status_rel <> 'ITEM_SEM_HEADER'.
    ENDIF.

  ELSE.

    IF p_csd = abap_true.
      DELETE gt_alvitens WHERE status_rel <> 'CASADO'.
    ELSEIF p_div = abap_true.
      DELETE gt_alvitens WHERE status_rel <> 'DIVERGENTE'.
    ELSEIF p_semrel = abap_true.
      DELETE gt_alvitens WHERE status_rel <> 'HEADER_SEM_ITEM'
      AND status_rel <> 'ITEM_SEM_HEADER'.

    ENDIF.
  ENDIF.
ENDFORM.
FORM execute.

  PERFORM get_dados.
  PERFORM cross_data.
  PERFORM options.

  IF p_res = abap_true.
    PERFORM display_alv USING gt_alvheader.
  ELSE.
    PERFORM display_alv USING gt_alvitens.
  ENDIF.

ENDFORM.
