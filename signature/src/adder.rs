#![no_std]

multiversx_sc::imports!();

use multiversx_sc::api::ED25519_SIGNATURE_BYTE_LEN;

pub type Signature<M> = ManagedByteArray<M, ED25519_SIGNATURE_BYTE_LEN>;
pub type SignArgs<M> = MultiValue2<ManagedAddress<M>, Signature<M>>; 

#[multiversx_sc::contract]
pub trait SignaturesVerification {
    #[init]
    fn init(&self) {}

    #[endpoint]
    fn verify(
        &self, 
        message: &ManagedBuffer,
        args: MultiValueEncoded<SignArgs<Self::Api>>
    ) {
        for arg in args {
            let (signer, signature) = arg.into_tuple();

            self.verify_signature(signer, &message, &signature);
        }
    }

    fn verify_signature(
        &self,
        signer: ManagedAddress<Self::Api>,
        message: &ManagedBuffer,
        signature: &Signature<Self::Api>,
    ) {
        let valid_signature = self.crypto().verify_ed25519(
            signer.as_managed_buffer(),
            message,
            signature.as_managed_buffer(),
        );
        require!(valid_signature, "Invalid signature");
    }
}
