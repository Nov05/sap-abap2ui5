CLASS znov05_cl_abap2ui5_01 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA:
      check_initialized TYPE abap_bool,
      input_user        TYPE string,
      input_date        TYPE d.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS znov05_cl_abap2ui5_01 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      input_user  = 'Nov05'.
      input_date = cl_abap_context_info=>get_system_date( ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BUTTON_POST'.
        client->popup_message_toast( |{ input_user } { input_date } - send to the server| ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack  ) ).
    ENDCASE.

    client->set_next( VALUE #( xml_main = z2ui5_cl_xml_view=>factory(
        )->shell(
        )->page(
                title          = 'abap2UI5 -' && cl_abap_char_utilities=>horizontal_tab &&
                                 input_user && '''s first application'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Source Code'
                    href = z2ui5_cl_xml_view=>hlp_get_source_code_url( app = me get = client->get( ) )
                    target = '_blank'
            )->get_parent(
            )->simple_form( title = 'Howdy, y''all!' editable = abap_true
                )->content( 'form'
                    )->title( 'Input Fields'
                    )->label( 'User'
                    )->input( value = client->_bind( input_user )
                    )->label( 'Date'
*                    )->input( value = client->_bind( input_date )
                    )->date_picker( client->_bind( input_date )
                    )->button(
                        text  = 'Post'
                        press = client->_event( 'BUTTON_POST' )
         )->get_root( )->xml_get( ) ) ).

  ENDMETHOD.
ENDCLASS.
