import Enc
import System.Environment
import System.IO

main :: IO ()
main = do
  putStrLn "Usage: ./this-exe enc real-pswd1 fake-pswd real-text-file-name fake-text-file-name output-file-name"
  putStrLn "Usage: ./this-exe dec pswd text-file-name output-file-name"
  args <- getArgs
  case args of
    ["enc", pswd1, pswd2, file1, file2, ofile] -> do
      real <- readFile file1
      fake <- readFile file2
      let code = simpleEnc (pswd1, real) (pswd2, fake)
      putStrLn $ code
      putStrLn $ "Above is encrypted code."
      putStrLn $ "Saved in " ++ ofile ++ "."
      writeFile ofile code

    ["dec", pswd, file, ofile] -> do
      code <- readFile file
      let text = simpleDec (pswd, code)
      putStrLn $ text
      putStrLn "Above is the decrypted text."
      putStrLn $ "Saved in " ++ "ofile" ++ "."
      writeFile ofile text

    _ -> putStrLn "Invalid use."
