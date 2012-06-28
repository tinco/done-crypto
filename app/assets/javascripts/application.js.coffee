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

$ ->
    # For helping the random number generator:
    $('body').click ->
        rng_seed_time()

@bignum_to_bits = (bignum) ->
    sjcl.codec.hex.toBits(bignum.toString(16))
@bytes_to_bits = (bytes) ->
    sjcl.codec.hex.toBits(array_to_hex_string(bytes))

@createAccount = () ->
    password = $('#password').val()
    rsakey = new RSAKey()
    rsakey.generate(1024,"3")

    $('#private_key').val(rsakey.n.toString(16) + ',' + rsakey.d.toString(16))
    $('#public_key').val(rsakey.n.toString(16) + ',' + rsakey.e.toString(16))

    @hashed_password = scrypt(
        string_to_array(password),
        string_to_array("DoneCryptoSalt"),
        8,24,24,32
    )

    encrypted_key = sjcl.encrypt(
        bytes_to_bits(hashed_password),
        bignum_to_bits(rsakey.d)
    )

    data =
        user:
            public_key:
                n: sjcl.codec.base64.fromBits(bignum_to_bits(rsakey.n))
                e: rsakey.e
            private_key:
                n: sjcl.codec.base64.fromBits(bignum_to_bits(rsakey.n))
                d: JSON.parse(encrypted_key)

    $.post('users', data, (result) ->
        window['id'] = result.id
    )

@encrypt = () ->
    data = string_to_array($('#body').val())
    key = aesEncrypt(data)
    $('#key').val(array_to_hex_string(key))
    $('#body').val(array_to_hex_string(data))

@send = () ->
    body = $('#body').val()
    key = $('#key').val()
    encrypted = key != ""
    data = body: $()

@aesEncrypt = (data, aes_pass) ->
    if not aes_pass?
        aes_pass = new Array(32)
        rng_get_bytes(aes_pass)
    pass = []
    arraycopy(aes_pass,0,pass,0,aes_pass.length)
    AES_ExpandKey(pass)
    AES_Encrypt(data, pass)
    return aes_pass
