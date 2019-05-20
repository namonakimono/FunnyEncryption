# Funny Encryption

A funny ‘encryption algorithm’ and its [demo pages](http://enc.yozora.moe).

```
let code = encrypt ("real", "You are awesome.") ("fake", "You are not awesome.")

decrypt ("real", code) = "You are awesome."

decrypt ("fake", code) = "You are not awesome."

decrypt (someother, code) = &'"%&!)%& -- Yet another ‘code’

```

This funny ‘encryption’ is written in Haskell; internally, it uses AES encryption with *electronic codebook* mode. The demo pages are hosted by Node.js on port 8084. In the root folder, there are `start` and `stop` shells for starting and stoping the server.

Source files for Enc/Dec functions and a simple cmd interface are in the (sub)folder Haskell.

The name of the complied executable file should be `FunnyEnc` and it is must be added to the `$PATH` so that it can be accessed directly in terminal. (The JavaScripts in demo pages directly invoke `FunnyEnc`.)


----

The basic idea (naive solution):

```
encrypt (k1,t1) (k2,t2) =
  encode (k1, t1 ++ "SEPARATOR") ++ 
  encode (k2, "SEPARATOR" ++ t2)

decrypt (k,c) =
  case decode (k,c) of
    t1 ++ "SEPARATOR" ++ #(&$XZ... -> t1
    #(&$XZ... ++ "SEPARATOR" ++ t2 -> t2
    #$XZ... ++ @&$#... ++ &%$@&... ->
      the first 1/2 of (#$XZ... ++ @&$#... ++ &%$@&...)
```

The problem comes to mind in April 2019 and the basic idea (naive solution) was inspired by Zhixuan Yang. Although the solution is quite simple and straightforward, it still takes me some time to struggle to handle the encoding problem for supporting UTF-8. Due to the encoding problem, the padding function is another pain. (Well, in research, I use `Char` and `String` only; in practice, we need to handle types such as `Word8`, `ByteString`, and `Text`. For ‘some reason’, neither `unpack . pack` nor `pack . unpack` is an identity function; the default `readFile` and `writeFile` functions also do not always work correctly due to the lack of encoding mode. Shall use functions with which we can indicate `TextEncoding`.) 


----

I know nothing about cryptography. Although AES is used, it still seems that the overall algorithm looks unsafe. For example, the `SEPARATOR` is fixed and the real text is half size of the encoded text. However, I think that it is possible to do the following for some improvement.

- Generate the `SEPARATOR`s from the `key`s instead of using fixed ones; also, we can use different `SEPARATOR` for real text and fake text.

- The real text and fake text could be preprocessed and compressed before encrypting. Perhaps this will reduce the size of the input data so that the relation between the size of the input text and the size of the encrypted text becomes vague.

- When we cannot find either `SEPARATOR` from the decrypted data, we can randomly pick decrypted bits instead of always using the first half of it.

----

Another fucking stuff is that the text in *textarea* element is regarded as UTF-8 by default by most modern web browsers. That is, we must save and read files using UTF-8 encoding. However, the encrypted ByteStream is not always valid UTF-8 sequence. As a workaround, we first encode the encrypted ByteStream in Base64, and ‘wrap it’ in UTF-8.

```
UTF-8 in Browser -> UTF-8 in files -> read as binary for encrypting -> 
convert to ByteString -> output encrypted ByteString -> 
convert to Base64 -> convert to (wrap in) UTF-8
```