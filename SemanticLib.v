Require Import HOASLib.
Require Import Denotation.
Require Import TypeChecking.

Open Scope matrix_scope.

(* ---------------------------------------*)
(*--------- Boxed Circuit Specs ----------*)
(* ---------------------------------------*)

(* TODO: add lemmas to proof_db *)
Lemma id_circ_spec : forall W ρ safe, WF_Matrix (2^⟦W⟧) (2^⟦W⟧) ρ -> 
  denote_box safe  (@id_circ W) ρ = ρ.
Proof.
  intros W ρ safe H.
  simpl. unfold denote_box. simpl.
  autorewrite with proof_db.
  rewrite add_fresh_split.
  simpl.
  unfold pad.
  simpl.
  rewrite Nat.sub_diag.
  rewrite kron_1_r.
  rewrite subst_pat_fresh_empty.
  rewrite denote_pat_fresh_id.
  rewrite super_I; auto.
Qed.

Lemma X_spec : forall (b safe : bool), denote_box safe (boxed_gate _X) (bool_to_matrix b) = 
                               bool_to_matrix (¬ b).
Proof. intros. vector_denote. destruct b; unfold bool_to_ket; simpl; Msimpl; easy. Qed.

Lemma init0_spec : forall safe, denote_box safe init0 (I (2^0)) = |0⟩⟨0|.
Proof. intros. matrix_denote. Msimpl. reflexivity. Qed.

Lemma init1_spec : forall safe, denote_box safe init1 (I (2^0)) = |1⟩⟨1|.
Proof. intros. matrix_denote. Msimpl. reflexivity. Qed.

Lemma assert0_spec : forall safe, denote_box safe assert0 |0⟩⟨0| = I 1. 
Proof.  
  destruct safe.
  - matrix_denote.
    Msimpl.
    solve_matrix.
  - matrix_denote.
    Msimpl.
    solve_matrix.
Qed.

Lemma assert1_spec : forall safe, denote_box safe assert1 |1⟩⟨1| = I 1. 
Proof.  
  destruct safe.
  - matrix_denote.
    Msimpl.
    solve_matrix.
  - matrix_denote.
    Msimpl.
    solve_matrix.
Qed.

Lemma init_spec : forall b safe, denote_box safe (init b) (I (2^0)) = bool_to_matrix b.
Proof. destruct b; [apply init1_spec | apply init0_spec]. Qed.

Lemma assert_spec : forall b safe, denote_box safe (assert b) (bool_to_matrix b) = I 1.
Proof. destruct b; [apply assert1_spec | apply assert0_spec]. Qed.


(* -----------------------------------------*)
(*--------- Reversible Circuit Specs -------*)
(* -----------------------------------------*)

Lemma CNOT_spec : forall (b1 b2 safe : bool), 
  denote_box safe CNOT (bool_to_matrix b1 ⊗ bool_to_matrix b2)
  = (bool_to_matrix b1 ⊗ bool_to_matrix (b1 ⊕ b2)).
Proof.
  vector_denote. destruct b1, b2; unfold bool_to_ket; simpl; Msimpl; solve_matrix.
Qed.

Lemma TRUE_spec : forall z safe, 
  denote_box safe TRUE (bool_to_matrix z) = bool_to_matrix (true ⊕ z). 
Proof. vector_denote. destruct z; unfold bool_to_ket; simpl; Msimpl; reflexivity. Qed.

Lemma FALSE_spec : forall z safe, 
    denote_box safe FALSE (bool_to_matrix z) = bool_to_matrix (false ⊕ z). 
Proof. vector_denote. destruct z; unfold bool_to_ket; simpl; Msimpl; reflexivity. Qed.

Lemma NOT_spec : forall (x z : bool), 
  forall safe, denote_box safe NOT (bool_to_matrix x ⊗ bool_to_matrix z) = 
  bool_to_matrix x ⊗ bool_to_matrix ((¬ x) ⊕ z).
Proof.
  vector_denote. 
  destruct x, z; unfold bool_to_ket; simpl; Msimpl; solve_matrix. 
Qed.

Lemma XOR_spec : forall (x y z safe : bool), 
    denote_box safe XOR (bool_to_matrix x ⊗ bool_to_matrix y ⊗ bool_to_matrix z)  = 
    bool_to_matrix x ⊗ bool_to_matrix y ⊗ bool_to_matrix (x ⊕ y ⊕ z).
Proof.  
  vector_denote. Msimpl.
  destruct x, y, z; simpl; solve_matrix. 
Qed.

Lemma AND_spec : forall (x y z safe : bool), 
    denote_box safe AND (bool_to_matrix x ⊗ bool_to_matrix y ⊗ bool_to_matrix z)  = 
    bool_to_matrix x ⊗ bool_to_matrix y ⊗ bool_to_matrix ((x && y) ⊕ z).
Proof. 
  vector_denote. Msimpl.
  destruct x, y, z; simpl; Msimpl; solve_matrix. 
Qed.

