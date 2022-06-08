{-# OPTIONS --safe #-}
module Example where
open import Agda.Builtin.Equality

_⇆_ : {A : Set} {a b c : A} → a ≡ b → b ≡ c → a ≡ c
refl ⇆ refl = refl
