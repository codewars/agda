{-# OPTIONS --safe #-}
module Example where
open import Agda.Builtin.Equality

_⇆_ : {A : Set} {a : A} → a ≡ a → a ≡ a → a ≡ a
refl ⇆ refl = refl
