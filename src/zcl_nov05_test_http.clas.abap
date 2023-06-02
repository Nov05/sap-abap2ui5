CLASS zcl_nov05_test_http DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension .

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS: get_html RETURNING VALUE(ui_html) TYPE string
                      RAISING   cx_abap_context_info_error.
ENDCLASS.



CLASS zcl_nov05_test_http IMPLEMENTATION.

  METHOD if_http_service_extension~handle_request.
*    response->set_text( 'Hello, the Internet!' ).
    response->set_text( get_html( ) ).
  ENDMETHOD.

  METHOD get_html.
    DATA(user_formatted_name) = cl_abap_context_info=>get_user_formatted_name( ).
    DATA(system_date) = cl_abap_context_info=>get_system_date( ).

    ui_html =  |<html> \n| &&
        |<body> \n| &&
        |<title>General Information</title> \n| &&
        |<p style="color:DodgerBlue;"> Hello there, { user_formatted_name } </p> \n | &&
        |<p> Today, the date is:  { system_date }| &&
        |<p> | &&
        |</body> \n| &&
        |</html> | .
  ENDMETHOD.

ENDCLASS.
