# FunnyEncryption
A funny encryption ‘algorithm’ and its demo pages.

Source files for Enc/Dec functions and a simple cmd interface are in the folder Haskell.

The default name of the complied executable file should be encdec and it is must be added to the `$PATH`. Because the JavaScripts in demo pages directly invoke `encdec`.

It is host on port 8084.


----

Basic idea:

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

The idea was inspired by Zhixuan Yang. Although the idea is quite simple and straightforward, it still takes me some time to strugle to handle the encoding problem to support Utf-8. Well, in research, I use `Char` and `String` only; in practice, we need to handle types such as `Word8`, `ByteString`, and `Text`. For some reason, neither `unpack . pack` nor `pack . unpack` is identity function.


----

I know nothing about cryptography; it seems that the algorithm looks unsafe overall due to the fixed `SEPARATOR` and the real text being half size of the encoded text. However, for improvement, I think there is possibility to:

- Generate the `SEPARATOR`s from the `key`s instead of using fixed ones; also, we can use different `SEPARATOR` for real text and fake text.

- The real text and fake text could be preprocessed and compressed before encrypting. Perhaps this will reduce the size of the input data so that the relation between the size of the input text and the size of the encrypted text becomes vague.

- When we cannot find either `SEPARATOR` from the decrypted data, we can randomly pick decrypted bits instead of always using the first half of it.
