/*---LEFT BAR ACCORDION----*/
$(".form_datetime").datetimepicker({format: 'yyyy-mm-dd hh:ii'});
$(".form_date-component").datetimepicker({format: 'yyyy-mm-dd'});
$(".form_datetime-component").datetimepicker({
    format: "yyyy-mm-dd HH:ii P"
});

window.sweetAlertConfirmConfig = {
  confirmButtonColor: '#66CD00',
};


$(function() {
    $('#nav-accordion').dcAccordion({
        eventType: 'click',
        autoClose: true,
        saveState: true,
        disableLink: true,
        speed: 'slow',
        showCount: false,
        autoExpand: true,
//        cookie: 'dcjq-accordion-1',
        classExpand: 'dcjq-current-parent'
    });
});

var Script = function () {

//    sidebar dropdown menu auto scrolling

    jQuery('#sidebar .sub-menu > a').click(function () {
        var o = ($(this).offset());
        diff = 250 - o.top;
        if(diff>0)
            $("#sidebar").scrollTo("-="+Math.abs(diff),500);
        else
            $("#sidebar").scrollTo("+="+Math.abs(diff),500);
    });

//    sidebar toggle

    $(function() {
        function responsiveView() {
            var wSize = $(window).width();
            if (wSize <= 768) {
                $('#container').addClass('sidebar-close');
                $('#sidebar > ul').hide();
            }

            if (wSize > 768) {
                $('#container').removeClass('sidebar-close');
                $('#sidebar > ul').show();
            }
        }
        $(window).on('load', responsiveView);
        $(window).on('resize', responsiveView);
    });

    $('.icon-reorder').click(function () {
        if ($('#sidebar > ul').is(":visible") === true) {
            $('#main-content').css({
                'margin-left': '0px'
            });
            $('#sidebar').css({
                'margin-left': '-210px'
            });
            $('#sidebar > ul').hide();
            $("#container").addClass("sidebar-closed");
        } else {
            $('#main-content').css({
                'margin-left': '210px'
            });
            $('#sidebar > ul').show();
            $('#sidebar').css({
                'margin-left': '0'
            });
            $("#container").removeClass("sidebar-closed");
        }
    });

// custom scrollbar
    $("#sidebar").niceScroll({styler:"fb",cursorcolor:"#e8403f", cursorwidth: '3', cursorborderradius: '10px', background: '#404040', spacebarenabled:false, cursorborder: ''});

    $("html").niceScroll({styler:"fb",cursorcolor:"#e8403f", cursorwidth: '6', cursorborderradius: '10px', background: '#404040', spacebarenabled:false,  cursorborder: '', zindex: '1000'});

// widget tools

    jQuery('.panel .tools .icon-chevron-down').click(function () {
        var el = jQuery(this).parents(".panel").children(".panel-body");
        if (jQuery(this).hasClass("icon-chevron-down")) {
            jQuery(this).removeClass("icon-chevron-down").addClass("icon-chevron-up");
            el.slideUp(200);
        } else {
            jQuery(this).removeClass("icon-chevron-up").addClass("icon-chevron-down");
            el.slideDown(200);
        }
    });

    jQuery('.panel .tools .icon-remove').click(function () {
        jQuery(this).parents(".panel").parent().remove();
    });


//    tool tips

    $('.tooltips').tooltip();

//    popovers

    $('.popovers').popover();



// custom bar chart

    if ($(".custom-bar-chart")) {
        $(".bar").each(function () {
            var i = $(this).find(".value").html();
            $(this).find(".value").html("");
            $(this).find(".value").animate({
                height: i
            }, 2000)
        })
    }


}();


$(function() {

  // Match to Bootstraps data-toggle for the modal
  // and attach an onclick event handler
  $('a[data-toggle="cmodal"]').on('click', function(e) {

    // From the clicked element, get the data-target arrtibute
    // which BS3 uses to determine the target modal
    var target_modal = $(e.currentTarget).data('target');
    // also get the remote content's URL
    var remote_content = $(e.currentTarget).data('href');

    // Find the target modal in the DOM
    var modal = $(target_modal);
    // Find the modal's <div class="modal-body"> so we can populate it
    var modalBody = $(target_modal + ' .modal-body');
    // console.log('location.pathname' + location.pathname)
    // Capture BS3's show.bs.modal which is fires
    // immediately when, you guessed it, the show instance method
    // for the modal is called
    modal.off('show.bs.modal').on('show.bs.modal', function () {
            // use your remote content URL to load the modal body
            modalBody.html('Loading..');
            modalBody.load(remote_content,function() {
                $("[data-toggle='switch']").wrap('<div class="switch" />').parent().bootstrapSwitch();
                
                CKEDITOR.config.height = 400;
                try {
                    CKEDITOR.replace('email_template_content');
                } catch (e) {
                        CKEDITOR.replace('site_page_content');
                }
                    
                
            })
        }).modal();
    modal.off('hidden.bs.modal').on('hidden.bs.modal', function () {
        if (window.submitForm == 'success') {
            window.location.reload(true);
            window.submitForm = false;
        }
    })

        // and show the modal
        //setTimeout(function(){  }, 2000);
        
    // Now return a false (negating the link action) to prevent Bootstrap's JS 3.1.1
    // from throwing a 'preventDefault' error due to us overriding the anchor usage.
    //return false;
  });

});


$(function() {

    // console.log(location.pathname)
        // Tags Input
        //$(".tagsinput").tagsInput();

        // Switch
        //$("[data-toggle='switch']").wrap('<div class="switch" />').parent().bootstrapSwitch();



});


jQuery(function($) {
    $('#savecampaign').on('click', function(event) {
        var $form = $('#new_campaign')
        if ($form.html() == undefined) 
            $form = $('form[id^="edit_campaign"]')
        var formData = $form.serialize()
        var spinner = $(this).find(".icon-spin:first");
        var submitBtn = $(this)
        var testcampaignBtn = $('#testcampaignemail')
        var errorDialog = $form.find(".alert-warning:first");
        var infoDialog = $form.find(".alert-info:first");
        var message = $form.find("#message-info");
        var messageUl = $form.find("#message");
        
        $.ajax({
            type: $form.attr('method'),
            url: $form.attr('action') + '.json',
            data: formData,
            beforeSend: function() {
                $('.form-group').removeClass('has-error has-feedback');
                $('.help-block').remove()
                spinner.removeClass('hidden');
                submitBtn.attr('disabled', true);
                testcampaignBtn.attr('disabled', true);
                messageUl.html('');
                errorDialog.addClass('hidden');
                infoDialog.addClass('hidden');
                // sleep(500)
            },
            success: function(data, status) {
                console.log(data.message)
                console.log(status)
                if (status == 'success') {
                    // infoDialog.removeClass('hidden');
                    // message.html(data.message);
                    swal({
                      type: 'success',
                      title: data.message,
                      showConfirmButton: false,
                      timer: 1500
                    })
                    if ($form.attr("id") == "new_campaign")
                        $form[0].reset();
                }
                
                // $target.html(data);
            },
            error(xhr,status,error) {
                console.log(status)
                 console.log(xhr)
                 // messageUl.html('');
                 errors = xhr.responseJSON
                   for (field in errors) {
                    input = $('#campaign_' + field )
                    input.closest('.form-group').addClass('has-error')
                    if (field == 'recipient_group_ids') {
                        $('#recipient_group').prepend('<p class="help-block"><i class="icon-warning-sign"></i> ' + errors[field][0] + '</p>')
                    } else {
                        input.closest('.form-group').append('<p class="help-block"><i class="icon-warning-sign"></i> ' + errors[field][0] + '</p>')
                    }
                    // messageUl.append('<li>' + errors[message] + '</li>');
                  }
                // errorDialog.removeClass('hidden');
                spinner.addClass('hidden');
                submitBtn.attr('disabled', false);
                testcampaignBtn.attr('disabled', false);
                swal({
                  type: 'error',
                  title: 'Error while saving campaign.',
                  showConfirmButton: false,
                  timer: 1500
                })
                
            }
        }).done(function() {
            spinner.addClass('hidden');
            submitBtn.attr('disabled', false);
            testcampaignBtn.attr('disabled', false);
        });

        event.preventDefault();
    });
});

jQuery(function($) {
    $('#testcampaignemail').on('click', function(e) {
        $form = $('#new_campaign')
        if ($form.html() == undefined) 
            $form = $('form[id^="edit_campaign"]')
        // console.log($form);
        var spinner = $(this).find(".icon-spin:first");

        if ($('#campaign_sender_name').val() == '') {
            alert('Please enter Sender Name');
            $('#new_campaign_tab a[href="#sender"]').tab('show')
            return false
        } else
        if ($('#campaign_sender_email').val() == '') {
            alert('Please enter Sender Email');
            $('#new_campaign_tab a[href="#sender"]').tab('show')
            return false
        } else
        if ($('#campaign_send_profile_id').val() == '') {
            alert('Please select Send Profile');
            $('#new_campaign_tab a[href="#sender"]').tab('show')
            return false
        } else
        if ($('#campaign_email_template_id').val() == '') {
            alert('Please select Email Template');
            $('#new_campaign_tab a[href="#template"]').tab('show')
            return false
        } 
        // else if ($('#campaign_site_page_id').val() == '') {
        //     alert('Please select Phishing Site Template');
        //     $('#new_campaign_tab a[href="#template"]').tab('show')
        // }

        var formData = $form.serialize();
        var submitBtn = $form.find("button[type='submit']:first");
        var message = $form.find("#message-info");
        var messageUl = $form.find("#message");
        var errorDialog = $form.find(".alert-warning:first");
        var infoDialog = $form.find(".alert-info:first");

        $.ajax({
            type: $form.attr('method'),
            url: $form.data('testcampaignemail') + '.json',
            data: formData,
            beforeSend: function() {
                spinner.removeClass('hidden');
                submitBtn.attr('disabled', true);
                $(this).attr('disabled', true);
                messageUl.html('');
                errorDialog.addClass('hidden');
                infoDialog.addClass('hidden');
                // sleep(500)
            },
            success: function(data, status) {
                console.log(data.message)
                console.log(status)
                if (status == 'success') {
                    swal({
                      type: 'success',
                      title: data.message,
                      showConfirmButton: false,
                      timer: 1500
                    })
                    // infoDialog.removeClass('hidden');
                    // message.html(data.message);
                }
                // $form[0].reset();
                // window.submitForm = 'success';
                // $target.html(data);
            },
            error(xhr,status,error) {
                console.log(status)
                 console.log(xhr)
                 messageUl.html('');
                 errors = xhr.responseJSON
                 var errorText = '';
                   for (message in errors) {
                    // messageUl.append('<li>' + errors[message] + '</li>');
                    errorText = errorText + errors[message] + '<br>'
                  }
                // errorDialog.removeClass('hidden');
                spinner.addClass('hidden');
                // swal({
                //       type: 'error',
                //       title: errorText,
                //       showConfirmButton: false,
                //       timer: 2500
                //     })
                swal({
                      type: 'error',
                      title: 'Oops...',
                      text: errorText,
                      footer: '<a href>Why do I have this issue?</a>',
                    })
                submitBtn.attr('disabled', false);
                $(this).attr('disabled', false);

            }
        }).done(function() {
            spinner.addClass('hidden');
            submitBtn.attr('disabled', false);
             $(this).attr('disabled', false);
        });

        event.preventDefault();

        
    })
})

jQuery(function($) {
    $('.modal-content').on('click', '#sendtestemail', function(event) {
   
        console.log('clicked');
        $form = $('#new_send_profile')
        if ($form.html() == undefined) 
            $form = $('form[id^="edit_send_profile"]')
        // console.log($form);
        var spinner = $(this).find(".icon-spin:first");

        if ($('#send_profile_address').val() == '') {
            alert('Please enter Mail Server address');
            return false
        } else if ($('#send_profile_port').val() == '') {
            alert('Please enter Mail Server port number');
            return false
        } else if ($('#send_profile_user_name').val() == '') {
            alert('Please enter Username');
            return false
        } else if ($('#send_profile_password').val() == '') {
            alert('Please enter Password');
            return false
        } 
        
        var formData = $form.serialize();
        var submitBtn = $form.find("button[type='submit']:first");
        var message = $form.find("#message-info");
        var messageUl = $form.find("#message");
        var errorDialog = $form.find(".alert-warning:first");
        var infoDialog = $form.find(".alert-info:first");

        $.ajax({
            type: $form.attr('method'),
            url: $form.data('sentestemail') + '.json',
            data: formData,
            beforeSend: function() {
                spinner.removeClass('hidden');
                submitBtn.attr('disabled', true);
                $(this).attr('disabled', true);
                messageUl.html('');
                errorDialog.addClass('hidden');
                infoDialog.addClass('hidden');
                // sleep(500)
            },
            success: function(data, status) {
                console.log(data.message)
                console.log(status)
                if (status == 'success') {
                    infoDialog.removeClass('hidden');
                    message.html(data.message);
                }
                // $form[0].reset();
                // window.submitForm = 'success';
                // $target.html(data);
            },
            error(xhr,status,error) {
                console.log(status)
                 console.log(xhr)
                 messageUl.html('');
                 errors = xhr.responseJSON
                   for (message in errors) {
                    messageUl.append('<li>' + errors[message] + '</li>');
                  }
                errorDialog.removeClass('hidden');
                spinner.addClass('hidden');
                submitBtn.attr('disabled', false);
                $(this).attr('disabled', false);
            }
        }).done(function() {
            spinner.addClass('hidden');
            submitBtn.attr('disabled', false);
             $(this).attr('disabled', false);
        });

        event.preventDefault();

        
    })
})

jQuery(function($) {
    $('.modal-content').on('submit', 'form.async', function(event) {
        var $form = $(this);
        var formData;
        var $target = $($form.attr('data-target'));
        var spinner = $(this).find(".icon-spin:first");
        var submitBtn = $(this).find("button[type='submit']:first");
        var errorDialog = $(this).find(".alert-warning:first");
        var infoDialog = $(this).find(".alert-info:first");
        var message = $(this).find("#message-info");
        var messageUl = $(this).find("#message");
        var fileUpload = $(this).find("input[type='file']:first")
        window.submitForm = false;

        if ($form.attr('id') == 'testemaiform') {
            var sender_name = $('#campaign_sender_name').val()
            if ($('#campaign_sender_name').val() == '' ||  $('#campaign_sender_email').val() == '') {
                alert('Error: You must enter the Sender Name and Sender Email.')
                return false
            }

            if ($('#campaign_send_profile_id').val() == '') {
                alert('Error: You must select a send profile.')
                return false
            }

            $('#testemail_sender_name').val($('#campaign_sender_name').val())
            $('#testemail_sender_email').val($('#campaign_sender_email').val())
            $('#testemail_send_profile_id').val($('#campaign_send_profile_id').val())
            // console.log('sender_name ' + $('#testemail_sender_name').val())
        }
        // console.log('id ' + $form.attr('id'))
        if (location.pathname != '/recipient_groups' && location.pathname != '/') { 
            formData = $form.serialize();
        } else {
            if (fileUpload.val() != '')
                formData = new FormData();
            else 
                formData = $form.serialize();
        }
        // formData = $form.serialize();
      
        //alert('post');
        $.ajax({
            type: $form.attr('method'),
            url: $form.attr('action') + '.json',
            data: formData,
            beforeSend: function() {
                spinner.removeClass('hidden');
                submitBtn.attr('disabled', true);
                messageUl.html('');
                errorDialog.addClass('hidden');
                infoDialog.addClass('hidden');
                // sleep(500)
            },
            success: function(data, status) {
                console.log(data.message)
                console.log(status)
                if (status == 'success') {
                    infoDialog.removeClass('hidden');
                    message.html(data.message);
                }
                if ($form.attr('id').match('/edit/')) {
                    $form[0].reset();
                }
                window.submitForm = 'success';
                // $target.html(data);
            },
            error(xhr,status,error) {
                console.log(status)
                 console.log(xhr)
                 messageUl.html('');
                 errors = xhr.responseJSON
                   for (message in errors) {
                    messageUl.append('<li>' + errors[message] + '</li>');
                  }
                errorDialog.removeClass('hidden');
                spinner.addClass('hidden');
                submitBtn.attr('disabled', false);
            }
        }).done(function() {
            spinner.addClass('hidden');
            submitBtn.attr('disabled', false);
        });

        event.preventDefault();
    });
});


$( document ).ready(function() {
    
    var timer;
   
    // if(location.href=='/contacts')
    function statusBar(campaign, percent) {
        var html = '<a href="#"><div class="task-info"><div class="desc">' + campaign.title + '</div><div class="percent">' + Math.round(percent) + '%'
        html = html + '</div></div><div class="progress progress-striped active"><div class="progress-bar"  role="progressbar" aria-valuenow="' + Math.round(percent) 
        html = html + '" aria-valuemin="0" aria-valuemax="100" style="width: ' + Math.round(percent) + '%"><span class="sr-only">' + Math.round(percent) + '% Complete</span></div></div></a>'
        $('.tasks-bar li:nth-child(3)').append(html)
    }
    function processResponse(data) {
        
        //var inprogress_count = 0

        $('.tasks-bar li:nth-child(3)').html('')
        // $('#inprogress table tbody tr').remove()
        // $('#saved table tbody tr').remove()
        // $('#scheduled table tbody tr').remove()
        // $('#completed table tbody tr').remove()
        var saved = saved_count = 0;
        var scheduled = scheduled_count = 0;
        var inprogress = inprogress_count = 0;
        var completed = completed_count = 0;

        for (var i = 0; i < data.length; i++) {
            var campaign = data[i];
            // console.log('update page')
            // $('#campaign_' + campaign.id + ' td:nth-child(5) i.icon-refresh.icon-spin').addClass('hide')
           
            switch(campaign.status) {
                case null : 
                case 0 : 
                    saved_count += 1
                    // $('#saved table thead').removeClass('hidden');
                    if (location.pathname == '/campaigns' || location.pathname == '/') {
                        $('#campaign_' + campaign.id + ' td:nth-child(1)').html("<i class='icon-calendar-empty' style='margin-right: 10px;'></i> " + campaign.title)
                        $('#campaign_' + campaign.id + ' td:nth-child(4)').html("<span class='badge bg-default'>Ready</span>")
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a').addClass('hide')
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a[data-original-title="Launch campaign"]').removeClass('hide')
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a[data-original-title="Edit campaign"]').removeClass('hide')
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a[data-original-title="Delete campaign"]').removeClass('hide')
                    }
                    
                    break;
                case 1 :
                    completed_count += 1
                    // $('#completed table thead').removeClass('hidden');
                    if (location.pathname == '/campaigns' || location.pathname == '/') {
                        $('#campaign_' + campaign.id + ' td:nth-child(1)').html("<i class='icon-ok-sign' style='color: #3a87ad; margin-right: 10px;'></i> " + campaign.title)
                        $('#campaign_' + campaign.id + ' td:nth-child(4)').html("<span class='badge bg-success'>Completed</span>")
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a').addClass('hide')
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a[data-original-title="View Result"]').removeClass('hide')
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a[data-original-title="Delete campaign"]').removeClass('hide')
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a[data-original-title="Launch campaign"]').removeClass('hide')
                    }

                    break;
                case 2 :
                    scheduled_count += 1
                    // $('#scheduled table thead').removeClass('hidden');
                    if (location.pathname == '/campaigns' || location.pathname == '/') {
                        $('#campaign_' + campaign.id + ' td:nth-child(1)').html("<i class='icon-time' style='margin-right: 10px;'></i> " + campaign.title)
                        $('#campaign_' + campaign.id + ' td:nth-child(4)').html("<span class='badge bg-warning'>Scheduled</span>")
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a').addClass('hide')
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a[data-original-title="Stop campaign"]').removeClass('hide')
                    }
                    
                    break;
                case 3 :
                    inprogress_count += 1
                    // $('#in-progress table thead').removeClass('hidden');
                    var percent = parseInt(campaign.total_completed) / parseInt(campaign.total_target) * 100
                    if (location.pathname == '/campaigns' || location.pathname == '/') {
                        $('#campaign_' + campaign.id + ' td:nth-child(1)').html("<i class='icon-refresh icon-spin' style='color: #FF6C60;margin-right: 10px;'></i> " + campaign.title)
                        $('#campaign_' + campaign.id + ' td:nth-child(4)').html("<span class='badge bg-primary'>" + Math.round(percent) + " %</span>")
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a').addClass('hide')
                        $('#campaign_' + campaign.id + ' td:nth-child(5) a[data-original-title="Stop campaign"]').removeClass('hide')
                    }
                    statusBar(campaign, percent)
                   
                    break;
                    
            }
            // $('#campaign_' + campaign.id + ' td:nth-child(4)').html(campaign.title)
        }
        

        if (inprogress_count > 0) {
            $('#inprogress a span').text(inprogress_count)
            $('p.green').html('You have ' + inprogress_count + ' campaign running')
        } else {
            $('p.green').html('There is no campaign running at this time')
            $('#inprogress a span').text('')
        }
    }

    // timer = setTimeout(fetchData, 5000)
    // console.log('start timer')
    function fetchCampaignData() {
        $.ajax({
            type: 'GET',
            url: '/campaigns/campaign_dashboard',
            beforeSend: function() {
            },
            success: function(data, status) {
                if (status == 'success') {
                        $('#campaign-list').html(data)
                        console.log('update campaign list')
                }
            },
            error(xhr,status,error) {
                console.log('fetchCampaignData() : ' + status)
                 console.log(xhr)
            }
        }).done(function() {
            // console.log ('restart timer')
           setTimeout(fetchCampaignData, 5000)
        });
    }

    function fetchData() {
        $.ajax({
            type: 'GET',
            url: '/campaigns.json',
            beforeSend: function() {
                // clearTimeout(timer)
                // console.log('cancel timer')
            },
            success: function(data, status) {
                // console.log(data)
                // console.log(status)
                if (status == 'success') {
                        processResponse(data)
                }
                // $target.html(data);
            },
            error(xhr,status,error) {
                console.log('fetchData() : ' + status)
                 console.log(xhr)
            }
        }).done(function() {
            // console.log ('restart timer')
           timer = setTimeout(fetchData, 5000)
        });
    }

    function fetchNotifications() {
        $.ajax({
            type: 'GET',
            url: '/notifications',
            success: function(data, status) {
                $('#header_notification_bar').html(data);
                var count = parseInt($('#notification_count').text()) || 0
                // console.log('count ' + count)
                // console.log('notification_count ' + window.notification_count)
                if (count > window.notification_count) {
                        // console.log('count > window.notification_count')
                   $.gritter.add({
                        title: 'New Notification',
                        image: '/img/bell.png',
                        text: 'You have ' + (count - window.notification_count) + ' new notifications',
                        sticky: false,
                        time: ''
                    });
                   window.notification_count = count
                } else {
                    // console.log('count == window.notification_count')
                }
            },
            error(xhr,status,error) {
                console.log('fetchNotifications() : ' + status)
                 console.log(xhr)
            }
        }).done(function() {
            // console.log ('restart timer : notifications')
            setTimeout(fetchNotifications, 5000)
        });
    }

    $('.top-menu').on('click', '#clearNotification', function(){
        
        $.ajax({
            type: 'POST',
            url: '/notifications',
            data: {
              _method: "delete", 
            },
            success: function(data, status) {
                $('#header_notification_bar').html(data);
                window.notification_count = 0
                $.gritter.add({
                        title: 'Success',
                        image: '/img/bell.png',
                        text: 'All notification is now cleared',
                        sticky: false,
                        time: ''
                    });
            },
            error(xhr,status,error) {
                console.log('clearNotification xhr: ' + status)
                console.log(xhr)
            }
        })
    })    
   
    window.notification_count = $('#notification_count').text() ? parseInt($('#notification_count').text()) : 0
    // console.log('notification_count ' + window.notification_count)
    // console.log($('#notification_count').text())
    fetchNotifications();
    // fetchCampaignData() 
    fetchData()

   
    console.log('start')

    $("#toggle_recipient_group").click(function(){
       var check = $(this).prop('checked');
       $("input[type='checkbox'][name='campaign[recipient_group_ids][]']").each(function(){
            $(this).prop('checked', check);
       })
    });
    $('.modal-content').on('click', '#toggle_campaign', function(event) {
       var check = $(this).prop('checked');
       $("input[type='checkbox'][name='report[campaign_ids][]']").each(function(){
            $(this).prop('checked', check);
       })
    });

    $('input, select, checkbox').change(function() { 
        fg = $(this).closest('.form-group')
        fg.removeClass('has-error')
        fg.find('.help-block').remove()
    });


});