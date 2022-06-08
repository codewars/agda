{-# OPTIONS --safe #-}
module ExampleTest where
open import Agda.Builtin.Equality
open import Example

check : {A : Set} {a b c : A} → a ≡ b → b ≡ c → a ≡ c
check = _⇆_
