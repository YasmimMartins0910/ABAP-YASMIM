*&---------------------------------------------------------------------*
*& Report ZR_YASMIM_13_CARGA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_yasmim_13_carga.

INCLUDE zr_yasmim_13_carga_top.
INCLUDE zr_yasmim_13_carga_f01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

    PERFORM value_request_file.

START-OF-SELECTION.

  PERFORM del.
  PERFORM execute.
