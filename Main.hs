module Main where

import           Control.Monad
import           Data.Char                     (toLower)
import           Numeric
import           System.Environment
import           Text.ParserCombinators.Parsec hiding (spaces)

data LispVal = Atom String
             | List [LispVal]
             | DottedList [LispVal] LispVal
             | Number Integer
             | Float Float
             | String String
             | Char Char
             | Bool Bool
             deriving Show

main :: IO ()
main = do
  (expr:_) <- getArgs
  putStrLn $ readExpr expr

symbol :: Parser Char
symbol = oneOf "!$%&|*+-/:<=>?@^_~"

-- see `lexeme` instead:
spaces :: Parser ()
spaces = skipMany1 space

parseString :: Parser LispVal
parseString = do
  char '"'
  x <- many (escapedChar <|> noneOf "\"")
  char '"'
  return $ String x

escapedChar :: Parser Char
escapedChar = do
  char '\\'
  c <- oneOf ['\\','"','n','r','t']
  return $ case c of
             '\"' -> c
             '\\' -> c
             'n'  -> '\n'
             'r'  -> '\r'
             't'  -> '\t'

parseAtom :: Parser LispVal
parseAtom = do
  first <- letter <|> symbol
  rest <- many (letter <|> digit <|> symbol)
  let atom = first:rest
  return $ Atom atom

parseChar :: Parser LispVal
parseChar = do
  string "#\\"
  s <- many1 letter
  return $ case (map toLower s) of
             "space"   -> Char ' '
             "newline" -> Char '\n'
             [x]       -> Char x

parseBool :: Parser LispVal
parseBool = do
  char '#'
  b <- oneOf "tfTF"
  return $ case (toLower b) of
             't' -> Bool True
             'f' -> Bool False

parseNumber :: Parser LispVal
parseNumber = try parseFloat <|> parsePlainNumber <|> parseRadixNumber

parsePlainNumber :: Parser LispVal
parsePlainNumber = many1 digit >>= return . Number . read

parseRadixNumber :: Parser LispVal
parseRadixNumber = char '#' >> (parseHexNumber <|> parseOctNumber)

parseHexNumber :: Parser LispVal
parseHexNumber = char 'x'
                 >> many (oneOf "0123456789abcdefABCDEF")
                 >>= return . Number . readWith readHex

parseOctNumber :: Parser LispVal
parseOctNumber = char 'o'
                 >> many (oneOf "01234567")
                 >>= return . Number . readWith readOct

parseFloat :: Parser LispVal
parseFloat = many digit
             <> many1 (char '.')
             <> many digit
             >>= return . Float . readWith readFloat

readWith :: (t -> [(a, b)]) -> t -> a
readWith f n = fst $ f n !! 0

parseExpr :: Parser LispVal
parseExpr = parseAtom
            <|> parseString
            <|> try parseChar
            <|> try parseNumber
            <|> try parseBool

readExpr :: String -> String
readExpr input = case parse parseExpr "lisp" input of
                   Left err  -> "No match: " ++ show err
                   Right val -> "Found value: " ++ show val
