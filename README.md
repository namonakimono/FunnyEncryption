# Funny Encryption
A funny ‘encryption algorithm’ and its demo pages.

```
let code = encrypt (123, "You are awesome.") (456, "You are not awesome.")

decrypt (123, code) = "You are awesome."

decrypt (456, code) = "You are not awesome."

decrypt (someother, code) = &'"%&!)%& -- Yet another ‘code’

```

This funny ‘encryption’ is written in Haskell; internally, it uses AES encryption with *electronic codebook* mode. The demo pages are hosted by Node.js on port 8084. In the root folder, there are `start` and `stop` shells for starting and stoping the server.

Source files for Enc/Dec functions and a simple cmd interface are in the (sub)folder Haskell.

The name of the complied executable file should be `FunnyEnc` and it is must be added to the `$PATH` so that it can be accessed directly in terminal. (The JavaScripts in demo pages directly invoke `FunnyEnc`.)


----

Basic idea (naive solution):

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

The problem comes to mind in April 2019 and the basic idea (naive solution) was inspired by my friend Zhixuan Yang. Although the solution is quite simple and straightforward, it still takes me some time to strugle to handle the encoding problem for supporting Utf-8. Due to the encoding problem, the padding function is another pain. (Well, in research, I use `Char` and `String` only; in practice, we need to handle types such as `Word8`, `ByteString`, and `Text`. For ‘some reason’, neither `unpack . pack` nor `pack . unpack` is identity function; the default `readFile` and `writeFile` functions also do not always work due to the lack of encoding mode. Shall use functions with which we can indicate `TextEncoding`.) 


----

I know nothing about cryptography; it seems that the algorithm looks unsafe overall. For example, the `SEPARATOR` is fixed and the real text is half size of the encoded text. However, I think that it is possible to do the following for some improvement.

- Generate the `SEPARATOR`s from the `key`s instead of using fixed ones; also, we can use different `SEPARATOR` for real text and fake text.

- The real text and fake text could be preprocessed and compressed before encrypting. Perhaps this will reduce the size of the input data so that the relation between the size of the input text and the size of the encrypted text becomes vague.

- When we cannot find either `SEPARATOR` from the decrypted data, we can randomly pick decrypted bits instead of always using the first half of it.

----