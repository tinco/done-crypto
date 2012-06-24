# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require_tree .

@createAccount = () ->
    AES_Init()
    password = $('#password').val()
    rsakey = new RSAKey()
    rsakey.generate(1024,"3")
    $('#private_key').val(rsakey.n.toString(16) + ',' + rsakey.d.toString(16))
    $('#public_key').val(rsakey.n.toString(16) + ',' + rsakey.e.toString(16))

    @hashed_password = scrypt(str2ab(password),str2ab("DoneCryptoSalt"),8,24,24,32)

    AES_ExpandKey(@hashed_password)
    encrypted_key = str2ab(rsakey.d.clone().toString(16))
    AES_Encrypt(encrypted_key, @hashed_password)

    data =
        user:
            public_key:
                n: rsakey.n.toString(16)
                e: rsakey.e.toString(16)
            private_key:
                n: rsakey.n.toString(16)
                d: ab2str(encrypted_key)

    $.post('users', data, (result) ->
        window['id'] = result.id
    )
