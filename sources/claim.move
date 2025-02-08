module claim::claim {
    use sui::coin::{Self, TreasuryCap};
    use sui::event;
    use std::string::String;

    // Constants
    const AMOUNT: u64 = 1000000000;

    // Events
    public struct Event has copy, drop, store {
        ca: String,
        name: String,
        symbol: String,
        description: String,
        uri: String,
    } 

    public fun create<T>(
        treasury: TreasuryCap<T>,
        ca: String,
        name: String,
        symbol: String,
        description: String,
        uri: String,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        let mut treasury_mut = treasury;
        coin::mint_and_transfer(&mut treasury_mut, AMOUNT, recipient, ctx);
        let _event = Event{
            ca: ca,
            name: name,
            symbol: symbol,
            description,
            uri: uri,
        };
        transfer::public_transfer<coin::TreasuryCap<T>>(treasury_mut, @0x0);
        event::emit<Event>(_event);
    }
} 

