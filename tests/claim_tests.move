
#[test_only]
module claim::claim_tests {
    use sui::coin::{Self, Coin};
    use sui::url;
    use sui::test_scenario;
    use claim::claim;
    use sui::pay;

    public struct CLAIM_TESTS has drop {}

    const TEST_ADDR: address = @0xA11CE;

    #[test]
    fun test_claim() {
        let mut scenario = test_scenario::begin(TEST_ADDR);
        let witness = CLAIM_TESTS{};
        let (treasury, metadata) = coin::create_currency(
            witness,
            6,
            b"COIN_TESTS",
            b"coin_name",
            b"description",
            option::some(url::new_unsafe_from_bytes(b"icon_url")),
            scenario.ctx()
        );

        let symbol = metadata.get_symbol<CLAIM_TESTS>().to_string();
        let name = metadata.get_name<CLAIM_TESTS>();
        let description = metadata.get_description<CLAIM_TESTS>();
        let icon_url = url::inner_url(metadata.get_icon_url<CLAIM_TESTS>().borrow()).to_string();
        let ca = metadata.get_symbol<CLAIM_TESTS>().to_string();

        claim::create(treasury, ca, name, symbol, description, icon_url, TEST_ADDR, scenario.ctx());
        scenario.next_epoch(TEST_ADDR);
        let coin = scenario.take_from_address<Coin<CLAIM_TESTS>>(TEST_ADDR);
        let value = coin.value();
        assert!(value == 1000000000);
        pay::keep(coin, scenario.ctx());
        transfer::public_freeze_object(metadata);
        scenario.end();
    }
}




