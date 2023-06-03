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
*    TRY.
**    response->set_text( 'Hello, the Internet!' ).
*        response->set_text( get_html( ) ).
*      CATCH cx_web_message_error cx_abap_context_info_error.
*        "handle exception
*        response->set_text( 'Oops!' ).
*    ENDTRY.

    z2ui5_cl_http_handler=>client = VALUE #(
       t_header = request->get_header_fields( )
       t_param  = request->get_form_fields( )
       body     = request->get_text( ) ).

    DATA(lt_config) = VALUE z2ui5_if_client=>ty_t_name_value(
        ( name = `data-sap-ui-theme`          value = `sap_horizon_hcb` )
        (  name = `src`                       value = `https://sdk.openui5.org/resources/sap-ui-core.js` )
        (  name = `data-sap-ui-libs`          value = `sap.m` )
        (  name = `data-sap-ui-bindingSyntax` value = `complex` )
        (  name = `data-sap-ui-frameOptions`  value = `trusted` )
        (  name = `data-sap-ui-compatVersion` value = `edge` )
        ).

    DATA(lv_resp) = SWITCH #( request->get_method( )
       WHEN 'GET'  THEN z2ui5_cl_http_handler=>http_get( t_config = lt_config )
       WHEN 'POST' THEN z2ui5_cl_http_handler=>http_post( ) ).

    response->set_status( 200 )->set_text( lv_resp ).
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
