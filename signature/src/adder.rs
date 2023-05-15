#![no_std]

multiversx_sc::imports!();

pub type SignatureType<M> = ManagedBuffer<M>;
pub type SignArgs<M> = MultiValue2<ManagedAddress<M>, SignatureType<M>>; 

#[multiversx_sc::contract]
pub trait Signature {
    #[init]
    fn init(&self) {}

    #[endpoint]
    fn verify(
        &self, 
        message: ManagedBuffer,
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
        signature: &SignatureType<Self::Api>,
    ) {
        let mut data = ManagedBuffer::new();
        let _ = message.dep_encode(&mut data);

        let valid_signature = self.crypto().verify_ed25519(
            signer.as_managed_buffer(),
            &data,
            signature,
        );
        require!(valid_signature, "Invalid signature");
    }
}
