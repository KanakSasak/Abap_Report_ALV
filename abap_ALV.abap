*&---------------------------------------------------------------------*
*& Report  ZREPORT_8
*&
*&---------------------------------------------------------------------*
*& Lalu Raynaldi Pratama Putra
*&
*&---------------------------------------------------------------------*

REPORT  ZREPORT_8.

TYPE-POOLS : SLIS.

DATA : IT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT TYPE SLIS_FIELDCAT_ALV,
      GT_EVENTS   TYPE SLIS_T_EVENT,
      IT_LAYOUT TYPE SLIS_LAYOUT_ALV.

TABLES: EKPO.

DATA: MSG TYPE STRING.

DATA: BEGIN OF DAT OCCURS 0,
        EBELN LIKE EKKO-EBELN,
        BSART LIKE EKKO-BSART,
        EBELP LIKE EKPO-EBELP,
        LIFNR LIKE EKKO-LIFNR,
        MATNR LIKE EKPO-MATNR,
        MENGE LIKE EKPO-MENGE,
        MEINS LIKE EKPO-MEINS,
      END OF DAT.

DATA: IT_DATA LIKE TABLE OF DAT WITH HEADER LINE.

SELECTION-SCREEN BEGIN OF BLOCK A1 WITH FRAME TITLE TEXT-001.

PARAMETERS: P_BUKRS LIKE BSEG-BUKRS OBLIGATORY.
SELECT-OPTIONS:S_EBELN FOR EKPO-EBELN.

SELECTION-SCREEN END OF BLOCK A1.

AT SELECTION-SCREEN.

  PERFORM GET_DATA.
  PERFORM DISPLAY_DATA.
  IF SY-UCOMM = 'PRINT'.
    CONCATENATE 'COMPANY CODE ->' P_BUKRS INTO MSG SEPARATED BY ''.
    MESSAGE MSG TYPE 'I'.
  ENDIF.
*  CONCATENATE 'COMPANY CODE ->' P_BUKRS INTO MSG SEPARATED BY ''.
*  MESSAGE MSG TYPE 'I'.




*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM GET_DATA.

  SELECT EKKO~EBELN EKKO~BSART EKPO~EBELP EKKO~LIFNR EKPO~MATNR EKPO~MENGE EKPO~MEINS
    FROM EKKO JOIN EKPO ON EKKO~EBELN = EKPO~EBELN
    INTO CORRESPONDING FIELDS OF TABLE IT_DATA UP TO 30 ROWS WHERE EKKO~EBELN IN S_EBELN AND EKKO~BUKRS EQ P_BUKRS.

  IF IT_DATA[] IS INITIAL.

    MESSAGE 'DATA KOSONG...!!!' TYPE 'I'.

  ENDIF.

ENDFORM.                    "GET_DATA

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM DISPLAY_DATA.

  CLEAR: IT_FIELDCAT, WA_FIELDCAT.
  REFRESH IT_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'EBELN'.
  WA_FIELDCAT-SELTEXT_M = 'PO NO'.
  WA_FIELDCAT-OUTPUTLEN = 15.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR :  WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'EBELP'.
  WA_FIELDCAT-SELTEXT_M = 'PO ITEM'.
  WA_FIELDCAT-OUTPUTLEN = 7.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR :  WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'BSART'.
  WA_FIELDCAT-SELTEXT_M = 'PO TPE'.
  WA_FIELDCAT-OUTPUTLEN = 8.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR :  WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'LIFNR'.
  WA_FIELDCAT-SELTEXT_M = 'VENDOR'.
  WA_FIELDCAT-OUTPUTLEN = 20.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR :  WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MATNR'.
  WA_FIELDCAT-SELTEXT_M = 'MATERIAL'.
  WA_FIELDCAT-OUTPUTLEN = 20.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR :  WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MENGE'.
  WA_FIELDCAT-SELTEXT_M = 'QTY'.
  WA_FIELDCAT-OUTPUTLEN = 6.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR :  WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MEINS'.
  WA_FIELDCAT-SELTEXT_M = 'UOM'.
  WA_FIELDCAT-OUTPUTLEN = 20.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR :  WA_FIELDCAT.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
*   I_CALLBACK_PROGRAM                = ' '
*   I_CALLBACK_PF_STATUS_SET          = ' '
   I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
     IT_FIELDCAT                       = IT_FIELDCAT
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
   IT_EVENTS                         = GT_EVENTS[]
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB                          = IT_DATA
* EXCEPTIONS
*   PROGRAM_ERROR                     = 1
*   OTHERS                            = 2
            .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.                    "DISPLAY_DATA

*&---------------------------------------------------------------------*
*&      Form  user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->R_UCOMM      text
*      -->RS_SELFIELD  text
*----------------------------------------------------------------------*
FORM USER_COMMAND USING R_UCOMM LIKE SY-UCOMM
                  RS_SELFIELD TYPE SLIS_SELFIELD.

* Check function code
  CASE R_UCOMM.
    WHEN '&IC1'.

    WHEN 'COBA2'.
      MESSAGE 'yess' TYPE 'I'.
    WHEN '&DATA_SAVE'.  "user presses SAVE

  ENDCASE.
ENDFORM.                    "user_command
