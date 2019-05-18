{-

encrypt (k1,t1) (k2,t2) = encode (k1, t1 ++ "SEPARATOR") ++ encode (k2, "SEPARATOR" ++ t2)
decrypt (k,c) =
  case decode (k,c) of
    t1 ++ "SEPARATOR" ++ #(&$XZ... -> t1
    #(&$XZ... ++ "SEPARATOR" ++ t2 -> t2
    #$XZ... ++ @&$#... ++ &%$@&... -> the first 1/2 of (#$XZ... ++ @&$#... ++ &%$@&...)

It takes me quite a long time to strugle to handle Unicode and Utf-8 encoding.

-}

module Enc where

import Data.Char (chr)
import Data.Algorithms.KMP
import Crypto.Cipher
import Data.ByteString (ByteString)
import Data.Hash.MD5
import qualified Data.ByteString.Char8 as C8
import qualified Data.ByteString as B
import Codec.Binary.UTF8.String as U8

type Code = String
type MKey = String
type BlockSize = Int

data Phase = RealText | FakeText
  deriving (Eq, Show)


-- auxiliary functions for handling String, ByteString, and Utf-8

toStr :: ByteString -> String
toStr = U8.decode . B.unpack

toBStr :: String -> ByteString
toBStr = B.pack . U8.encode

initAES256 :: String -> AES256
initAES256 = either (error . show) cipherInit . makeKey . toBStr


aesEncStrInterface :: Phase -> String -> String -> ByteString
aesEncStrInterface phase key s =
  let cipher = initAES256 key
      bs = toBStr s
  in  ecbEncrypt cipher $ myPadding phase bs (blockSize cipher)


-- c2w8 :: Char -> GHC.Word.Word8
c2w8 = fromIntegral . fromEnum

-- padding the input to multiple of block size
myPadding :: Phase -> ByteString -> BlockSize -> ByteString
myPadding RealText bs sz =
  let sepStrT = toBStr (sepStr RealText)
  in  case B.length bs `mod` sz of
        0 -> bs  `B.append`  sepStrT  `B.append`
              B.replicate (sz - B.length sepStrT) (c2w8 '<')
        k -> if (sz - k - B.length sepStrT) >= 0
               then bs `B.append` sepStrT `B.append`
                     B.replicate (sz - k - B.length sepStrT) (c2w8 '<')
               else bs `B.append` sepStrT `B.append`
                     B.replicate (2*sz - k - B.length sepStrT) (c2w8 '<')

myPadding FakeText bs sz =
  let sepStrD = toBStr (sepStr FakeText)
  in  case B.length bs `mod` sz of
        0 -> B.replicate (sz - B.length sepStrD) (c2w8 '>')  `B.append`
                sepStrD `B.append` bs
        k -> if (sz - k - B.length sepStrD) >= 0
              then B.replicate (sz - k - B.length sepStrD) (c2w8 '>')
                    `B.append` sepStrD `B.append` bs
              else B.replicate (2*sz - k - B.length sepStrD) (c2w8 '>')
                    `B.append` sepStrD `B.append` bs



-- set to multiple of 16 (minimum block size)
sepStr :: Phase -> String
sepStr RealText  = "$InMiddle$<<<<<<"
sepStr FakeText = ">>>>>>$InMiddle$"


simpleEnc :: (MKey, String) -> (MKey, String) -> String
simpleEnc (pswd1, real) (pswd2, fake) =
  let (key1, key2) = (md5s (Str pswd1), md5s (Str pswd2))
      code1 = aesEncStrInterface RealText key1 real
      code2 = aesEncStrInterface FakeText key2 fake
  in  C8.unpack $ code1 `B.append` code2


simpleDec :: (MKey, String) -> String
simpleDec (pswd, code) =
  let key = md5s (Str pswd)
  in  throwAwayUselessPart . toStr $ ecbDecrypt (initAES256 key) (C8.pack code)

throwAwayUselessPart :: String -> String
throwAwayUselessPart str =
  let sepStrT = (sepStr RealText)
      sepStrD = (sepStr FakeText)
  -- first try if using the correct key
  in  case match (build sepStrT) str of
        [i] -> take i str
        []  -> case match (build sepStrD) str of
                [j] -> drop (j + length sepStrD) str
                -- Assuming the fake message and real message is about the same length.
                _   -> take (length str `div`2) str
        a   -> error "Impossible. You know the hidden separator? Cheater."



-- test data

-- key size = 32
key1 = "real"
key2 = "fake"


realText :: String
realText = "\128522I love you! ლ(′◉❥◉｀ლ)"

fakeText :: String
fakeText = "\128546You hate me..."

test1 decKey = putStrLn $ curry simpleDec decKey $ simpleEnc (key1, realText) (key2, fakeText)

chrtest1 = putStrLn . toStr . toBStr $ realText
chrtest2 = putStrLn . C8.unpack . C8.pack $ realText

-----------
