*&---------------------------------------------------------------------*
*& Include          ZR_YASMIM_13_CARGA_TOP
*&---------------------------------------------------------------------*

DATA: go_salv_table TYPE REF TO cl_salv_table.

DATA: gt_table    TYPE filetable,
      gt_data_tab TYPE STANDARD TABLE OF string,
      gt_c100     TYPE TABLE OF ztb_c100_yas,
      gt_c170     TYPE TABLE OF ztb_c170_yas,
      gt_zstc100  TYPE TABLE OF zst_header_log_yas,
      gt_zstc170  TYPE TABLE OF zst_item_log_yas.

DATA: gv_rc TYPE i.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_rdb1 RADIOBUTTON GROUP gr1,
              p_rdb2 RADIOBUTTON GROUP gr1,

              p_del AS CHECKBOX.


  PARAMETERS: p_file TYPE rlgrap-filename.

SELECTION-SCREEN END OF BLOCK b1.
