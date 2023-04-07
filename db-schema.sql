CREATE EXTENSION postgis;

create table ar_internal_metadata
(
    key        varchar   not null
        primary key,
    value      varchar,
    created_at timestamp not null,
    updated_at timestamp not null
);

create table danube_communication_preferences
(
    id   integer default nextval('danube_communication_preferences_id_seq'::regclass) not null
        primary key,
    name varchar
);

create table danube_holidays
(
    id         integer default nextval('danube_holidays_id_seq'::regclass) not null
        primary key,
    name       varchar,
    date       date,
    global     boolean default false                                       not null,
    created_at timestamp                                                   not null,
    updated_at timestamp                                                   not null
);

create table danube_holidays_spree_zones
(
    id         integer default nextval('danube_holidays_spree_zones_id_seq'::regclass) not null
        primary key,
    holiday_id integer,
    zone_id    integer
);

create index index_danube_holidays_spree_zones_on_holiday_id
    on danube_holidays_spree_zones (holiday_id);

create index index_danube_holidays_spree_zones_on_zone_id
    on danube_holidays_spree_zones (zone_id);

create table danube_salutations
(
    id         integer default nextval('danube_salutations_id_seq'::regclass) not null
        primary key,
    abbr       varchar,
    created_at timestamp                                                      not null,
    updated_at timestamp                                                      not null
);

create index index_danube_salutations_on_abbr
    on danube_salutations (abbr);

create table danube_supermarket_translations
(
    id                    integer default nextval('danube_supermarket_translations_id_seq'::regclass) not null
        primary key,
    danube_supermarket_id integer                                                                     not null,
    locale                varchar                                                                     not null,
    created_at            timestamp                                                                   not null,
    updated_at            timestamp                                                                   not null,
    name                  varchar,
    address1              varchar,
    address2              varchar,
    city                  varchar,
    description           text
);

create index index_danube_supermarket_translations_on_danube_supermarket_id
    on danube_supermarket_translations (danube_supermarket_id);

create index index_danube_supermarket_translations_on_locale
    on danube_supermarket_translations (locale);

create table danube_supermarkets
(
    id                                       integer          default nextval('danube_supermarkets_id_seq'::regclass) not null
        primary key,
    name                                     varchar,
    address1                                 varchar,
    address2                                 varchar,
    city                                     varchar,
    zipcode                                  varchar,
    phone                                    varchar,
    alternative_phone                        varchar,
    country_id                               integer,
    state_id                                 integer,
    zone_id                                  integer,
    created_at                               timestamp,
    updated_at                               timestamp,
    district_id                              integer,
    visible                                  boolean          default true,
    latitude                                 double precision default 0.0,
    longitude                                double precision default 0.0,
    time_slots_schedule_time_offset_override integer,
    is_aisle_map_enabled                     boolean          default false,
    code                                     varchar,
    printer_id                               integer,
    referrer_amount                          numeric(20, 5)   default 0.0,
    payment_options                          jsonb            default '{}'::jsonb,
    is_cartonization_enabled                 boolean          default false                                           not null,
    express                                  boolean          default false,
    express_fee                              numeric(20, 5)   default 0.0                                             not null,
    express_free_orders                      integer          default 10                                              not null,
    price_increment_percentage               double precision,
    available_roles                          jsonb            default '{}'::jsonb,
    call_masking                             boolean          default false,
    is_fulfilment_center                     boolean          default false,
    min_item_total_for_free_delivery         numeric(20, 5)   default NULL::numeric
);

create index index_danube_supermarkets_on_country_id
    on danube_supermarkets (country_id);

create index index_danube_supermarkets_on_district_id
    on danube_supermarkets (district_id);

create index index_danube_supermarkets_on_state_id
    on danube_supermarkets (state_id);

create index index_danube_supermarkets_on_zone_id
    on danube_supermarkets (zone_id);

create table danube_time_slots
(
    id         integer default nextval('danube_time_slots_id_seq'::regclass) not null
        primary key,
    start_time time,
    end_time   time,
    created_at timestamp                                                     not null,
    updated_at timestamp                                                     not null,
    enabled    boolean default true
);

create table friendly_id_slugs
(
    id             integer default nextval('friendly_id_slugs_id_seq'::regclass) not null
        primary key,
    slug           varchar                                                       not null,
    sluggable_id   integer                                                       not null,
    sluggable_type varchar(50),
    scope          varchar,
    created_at     timestamp,
    updated_at     timestamp,
    locale         varchar
);

create index index_friendly_id_slugs_on_locale
    on friendly_id_slugs (locale);

create index index_friendly_id_slugs_on_slug_and_sluggable_type_and_locale
    on friendly_id_slugs (slug, sluggable_type, locale);

create index index_friendly_id_slugs_on_sluggable_id
    on friendly_id_slugs (sluggable_id);

create index index_friendly_id_slugs_on_sluggable_type
    on friendly_id_slugs (sluggable_type);

create unique index index_friendly_id_slugs_uniqueness
    on friendly_id_slugs (slug, sluggable_type, scope, locale);

create table schema_migrations
(
    version varchar not null
        primary key
);

create table spree_addresses
(
    id                                  integer default nextval('spree_addresses_id_seq'::regclass) not null
        primary key,
    firstname                           varchar,
    lastname                            varchar,
    address1                            varchar,
    address2                            varchar,
    city                                varchar,
    zipcode                             varchar,
    phone                               varchar,
    state_name                          varchar,
    alternative_phone                   varchar,
    company                             varchar,
    state_id                            integer,
    country_id                          integer,
    created_at                          timestamp,
    updated_at                          timestamp,
    district_id                         integer,
    latitude                            double precision,
    longitude                           double precision,
    house_number                        varchar,
    salutation                          integer,
    address_book_id                     integer,
    driver_meta_data                    jsonb,
    location_changed                    boolean default false,
    magerecord_auto_assigned_salutation boolean,
    magerecord_address_entity_id        integer,
    mobile_number_country_code          varchar default '966'::character varying
);

create index index_addresses_on_firstname
    on spree_addresses (firstname);

create index index_addresses_on_lastname
    on spree_addresses (lastname);

create index index_spree_addresses_on_country_id
    on spree_addresses (country_id);

create index index_spree_addresses_on_district_id
    on spree_addresses (district_id);

create index index_spree_addresses_on_state_id
    on spree_addresses (state_id);

create table spree_adjustment_reasons
(
    id         integer default nextval('spree_adjustment_reasons_id_seq'::regclass) not null
        primary key,
    name       varchar,
    code       varchar,
    active     boolean default true,
    created_at timestamp,
    updated_at timestamp
);

create index index_spree_adjustment_reasons_on_active
    on spree_adjustment_reasons (active);

create index index_spree_adjustment_reasons_on_code
    on spree_adjustment_reasons (code);

create table spree_assets
(
    id                      integer default nextval('spree_assets_id_seq'::regclass) not null
        primary key,
    viewable_type           varchar,
    viewable_id             integer,
    attachment_width        integer,
    attachment_height       integer,
    attachment_file_size    integer,
    position                integer,
    attachment_content_type varchar,
    attachment_file_name    varchar,
    type                    varchar(75),
    attachment_updated_at   timestamp,
    alt                     text,
    created_at              timestamp,
    updated_at              timestamp
);

create index index_assets_on_viewable_id
    on spree_assets (viewable_id);

create index index_assets_on_viewable_type_and_type
    on spree_assets (viewable_type, type);

create table spree_authentication_methods
(
    id          integer default nextval('spree_authentication_methods_id_seq'::regclass) not null
        primary key,
    environment varchar,
    provider    varchar,
    api_key     varchar,
    api_secret  varchar,
    active      boolean,
    created_at  timestamp,
    updated_at  timestamp
);

create table spree_calculators
(
    id              integer default nextval('spree_calculators_id_seq'::regclass) not null
        primary key,
    type            varchar,
    calculable_type varchar,
    calculable_id   integer,
    created_at      timestamp,
    updated_at      timestamp,
    preferences     text
);

create index index_spree_calculators_on_calculable_id_and_calculable_type
    on spree_calculators (calculable_id, calculable_type);

create index index_spree_calculators_on_id_and_type
    on spree_calculators (id, type);

create table spree_cartons
(
    id                        integer default nextval('spree_cartons_id_seq'::regclass) not null
        primary key,
    number                    varchar,
    external_number           varchar,
    stock_location_id         integer,
    address_id                integer,
    shipping_method_id        integer,
    tracking                  varchar,
    shipped_at                timestamp,
    created_at                timestamp,
    updated_at                timestamp,
    imported_from_shipment_id integer
);

create index index_spree_cartons_on_external_number
    on spree_cartons (external_number);

create unique index index_spree_cartons_on_imported_from_shipment_id
    on spree_cartons (imported_from_shipment_id);

create unique index index_spree_cartons_on_number
    on spree_cartons (number);

create index index_spree_cartons_on_stock_location_id
    on spree_cartons (stock_location_id);

create table spree_comment_types
(
    id         integer default nextval('spree_comment_types_id_seq'::regclass) not null
        primary key,
    name       varchar,
    applies_to varchar,
    created_at timestamp,
    updated_at timestamp
);

create table spree_comments
(
    id                integer default nextval('spree_comments_id_seq'::regclass) not null
        primary key,
    title             varchar(50),
    comment           text,
    commentable_type  varchar,
    commentable_id    integer,
    user_id           integer,
    created_at        timestamp,
    updated_at        timestamp,
    comment_type_id   integer,
    customer_notified boolean
);

create index index_spree_comments_on_commentable_id
    on spree_comments (commentable_id);

create index index_spree_comments_on_commentable_type
    on spree_comments (commentable_type);

create index index_spree_comments_on_user_id
    on spree_comments (user_id);

create table spree_countries
(
    id                      integer       default nextval('spree_countries_id_seq'::regclass) not null
        primary key,
    iso_name                varchar,
    iso                     varchar,
    iso3                    varchar,
    name                    varchar,
    numcode                 integer,
    states_required         boolean       default false,
    updated_at              timestamp,
    created_at              timestamp,
    currency                varchar       default 'SAR'::character varying,
    vat_percentage          numeric(8, 2) default 15.0                                        not null,
    flag_image_file_name    varchar,
    flag_image_content_type varchar,
    flag_image_file_size    bigint,
    flag_image_updated_at   timestamp,
    default_supermarket_id  integer
        constraint fk_rails_170860c3b8
            references danube_supermarkets
            on delete set null,
    currency_precision      integer       default 2
);

create index index_spree_countries_on_iso
    on spree_countries (iso);

create table spree_credit_cards
(
    id                          integer default nextval('spree_credit_cards_id_seq'::regclass) not null
        primary key,
    month                       varchar,
    year                        varchar,
    cc_type                     varchar,
    last_digits                 varchar,
    gateway_customer_profile_id varchar,
    gateway_payment_profile_id  varchar,
    created_at                  timestamp,
    updated_at                  timestamp,
    name                        varchar,
    user_id                     integer,
    payment_method_id           integer,
    "default"                   boolean default false                                          not null,
    address_id                  integer,
    bin                         integer
);

create index index_spree_credit_cards_on_payment_method_id
    on spree_credit_cards (payment_method_id);

create index index_spree_credit_cards_on_user_id
    on spree_credit_cards (user_id);

create table spree_customer_returns
(
    id                integer default nextval('spree_customer_returns_id_seq'::regclass) not null
        primary key,
    number            varchar,
    stock_location_id integer,
    created_at        timestamp,
    updated_at        timestamp
);

create table spree_district_translations
(
    id                integer default nextval('spree_district_translations_id_seq'::regclass) not null
        primary key,
    spree_district_id integer                                                                 not null,
    locale            varchar                                                                 not null,
    created_at        timestamp                                                               not null,
    updated_at        timestamp                                                               not null,
    name              varchar,
    abbr              varchar
);

create index index_spree_district_translations_on_locale
    on spree_district_translations (locale);

create index index_spree_district_translations_on_spree_district_id
    on spree_district_translations (spree_district_id);

create table spree_districts
(
    id                      integer default nextval('spree_districts_id_seq'::regclass) not null
        primary key,
    name                    varchar,
    abbr                    varchar,
    state_id                integer,
    country_id              integer,
    created_at              timestamp                                                   not null,
    updated_at              timestamp                                                   not null,
    region                  geography(Polygon, 4326),
    center                  geography(Point, 4326),
    perform_region_checking boolean default false,
    visible                 boolean default true,
    orders_per_batch        integer,
    rank                    integer default 100
);

create index index_spree_districts_on_country_id
    on spree_districts (country_id);

create index index_spree_districts_on_state_id
    on spree_districts (state_id);

create index index_spree_districts_on_center
    on spree_districts using gist (center);

create index index_spree_districts_on_region
    on spree_districts using gist (region);

create table spree_feedback_reviews
(
    id         integer default nextval('spree_feedback_reviews_id_seq'::regclass) not null
        primary key,
    user_id    integer,
    review_id  integer                                                            not null,
    rating     integer default 0,
    comment    text,
    created_at timestamp,
    updated_at timestamp,
    locale     varchar default 'en'::character varying
);

create index index_spree_feedback_reviews_on_review_id
    on spree_feedback_reviews (review_id);

create index index_spree_feedback_reviews_on_user_id
    on spree_feedback_reviews (user_id);

create table spree_fulfilments
(
    id                     integer default nextval('spree_fulfilments_id_seq'::regclass) not null
        primary key,
    order_id               integer,
    state                  varchar,
    created_at             timestamp                                                     not null,
    updated_at             timestamp                                                     not null,
    cancel_reason          varchar,
    packer_checked_by_step integer default 0
);

create index index_spree_fulfilments_on_order_id
    on spree_fulfilments (order_id);

create index index_spree_fulfilments_on_state
    on spree_fulfilments (state);

create table spree_inventory_units
(
    id           integer default nextval('spree_inventory_units_id_seq'::regclass) not null
        primary key,
    state        varchar,
    variant_id   integer,
    order_id     integer,
    shipment_id  integer,
    created_at   timestamp,
    updated_at   timestamp,
    pending      boolean default true,
    line_item_id integer,
    carton_id    integer
);

create index index_inventory_units_on_order_id
    on spree_inventory_units (order_id);

create index index_inventory_units_on_shipment_id
    on spree_inventory_units (shipment_id);

create index index_inventory_units_on_variant_id
    on spree_inventory_units (variant_id);

create index index_spree_inventory_units_on_carton_id
    on spree_inventory_units (carton_id);

create index index_spree_inventory_units_on_line_item_id
    on spree_inventory_units (line_item_id);

create table spree_line_item_actions
(
    id           integer default nextval('spree_line_item_actions_id_seq'::regclass) not null
        primary key,
    line_item_id integer                                                             not null,
    action_id    integer                                                             not null,
    quantity     integer default 0,
    created_at   timestamp,
    updated_at   timestamp
);

create index index_spree_line_item_actions_on_action_id
    on spree_line_item_actions (action_id);

create index index_spree_line_item_actions_on_line_item_id
    on spree_line_item_actions (line_item_id);

create table spree_line_items
(
    id                     integer        default nextval('spree_line_items_id_seq'::regclass) not null
        primary key,
    variant_id             integer,
    order_id               integer,
    quantity               integer                                                             not null,
    price                  numeric(20, 5)                                                      not null,
    created_at             timestamp,
    updated_at             timestamp,
    cost_price             numeric(20, 5),
    tax_category_id        integer,
    adjustment_total       numeric(20, 5) default 0.0,
    additional_tax_total   numeric(20, 5) default 0.0,
    promo_total            numeric(20, 5) default 0.0,
    included_tax_total     numeric(20, 5) default 0.0                                          not null,
    requested_quantity     integer,
    in_stock               boolean        default true,
    replaced               boolean,
    replacement            boolean,
    added_after_purchase   boolean        default false,
    removed_after_purchase boolean        default false,
    comments               text,
    inventory_stock_used   integer,
    offline_price          numeric(20, 5),
    on_sale                boolean        default false,
    free_sample            boolean        default false
);

create index index_spree_line_items_on_order_id
    on spree_line_items (order_id);

create index index_spree_line_items_on_variant_id
    on spree_line_items (variant_id);

create index index_spree_line_items_on_created_at
    on spree_line_items (created_at);

create table spree_log_entries
(
    id          integer default nextval('spree_log_entries_id_seq'::regclass) not null
        primary key,
    source_type varchar,
    source_id   integer,
    details     text,
    created_at  timestamp,
    updated_at  timestamp
);

create index index_spree_log_entries_on_source_id_and_source_type
    on spree_log_entries (source_id, source_type);

create table spree_option_type_prototypes
(
    prototype_id   integer,
    option_type_id integer,
    id             integer default nextval('spree_option_type_prototypes_id_seq'::regclass) not null
        primary key,
    created_at     timestamp,
    updated_at     timestamp
);

create table spree_option_type_translations
(
    id                   integer default nextval('spree_option_type_translations_id_seq'::regclass) not null
        primary key,
    spree_option_type_id integer                                                                    not null,
    locale               varchar                                                                    not null,
    created_at           timestamp                                                                  not null,
    updated_at           timestamp                                                                  not null,
    name                 varchar,
    presentation         varchar
);

create index index_spree_option_type_translations_on_locale
    on spree_option_type_translations (locale);

create index index_spree_option_type_translations_on_spree_option_type_id
    on spree_option_type_translations (spree_option_type_id);

create table spree_option_types
(
    id           integer default nextval('spree_option_types_id_seq'::regclass) not null
        primary key,
    name         varchar(100),
    presentation varchar(100),
    position     integer default 0                                              not null,
    created_at   timestamp,
    updated_at   timestamp
);

create index index_spree_option_types_on_position
    on spree_option_types (position);

create table spree_option_value_translations
(
    id                    integer default nextval('spree_option_value_translations_id_seq'::regclass) not null
        primary key,
    spree_option_value_id integer                                                                     not null,
    locale                varchar                                                                     not null,
    created_at            timestamp                                                                   not null,
    updated_at            timestamp                                                                   not null,
    name                  varchar,
    presentation          varchar
);

create index index_spree_option_value_translations_on_locale
    on spree_option_value_translations (locale);

create index index_spree_option_value_translations_on_spree_option_value_id
    on spree_option_value_translations (spree_option_value_id);

create table spree_option_values
(
    id             integer default nextval('spree_option_values_id_seq'::regclass) not null
        primary key,
    position       integer,
    name           varchar,
    presentation   varchar,
    option_type_id integer,
    created_at     timestamp,
    updated_at     timestamp
);

create index index_spree_option_values_on_option_type_id
    on spree_option_values (option_type_id);

create index index_spree_option_values_on_position
    on spree_option_values (position);

create table spree_option_values_variants
(
    variant_id      integer,
    option_value_id integer,
    id              integer default nextval('spree_option_values_variants_id_seq'::regclass) not null
        primary key,
    created_at      timestamp,
    updated_at      timestamp
);

create index index_option_values_variants_on_variant_id_and_option_value_id
    on spree_option_values_variants (variant_id, option_value_id);

create index index_spree_option_values_variants_on_variant_id
    on spree_option_values_variants (variant_id);

create table spree_order_mutexes
(
    id         integer default nextval('spree_order_mutexes_id_seq'::regclass) not null
        primary key,
    order_id   integer                                                         not null,
    created_at timestamp
);

create unique index index_spree_order_mutexes_on_order_id
    on spree_order_mutexes (order_id);

create table spree_order_stock_locations
(
    id                 integer default nextval('spree_order_stock_locations_id_seq'::regclass) not null
        primary key,
    order_id           integer,
    variant_id         integer,
    quantity           integer,
    stock_location_id  integer,
    shipment_fulfilled boolean default false                                                   not null,
    created_at         timestamp,
    updated_at         timestamp
);

create index index_spree_order_stock_locations_on_order_id
    on spree_order_stock_locations (order_id);

create index index_spree_order_stock_locations_on_variant_id
    on spree_order_stock_locations (variant_id);

create index index_spree_order_stock_locations_on_stock_location_id
    on spree_order_stock_locations (stock_location_id);

create table spree_orders
(
    id                         integer        default nextval('spree_orders_id_seq'::regclass) not null
        primary key,
    number                     varchar(32)                                                     not null,
    item_total                 numeric(20, 5) default 0.0                                      not null,
    total                      numeric(20, 5) default 0.0                                      not null,
    state                      varchar,
    adjustment_total           numeric(20, 5) default 0.0                                      not null,
    user_id                    integer,
    completed_at               timestamp,
    bill_address_id            integer,
    ship_address_id            integer,
    payment_total              numeric(20, 5) default 0.0,
    shipment_state             varchar,
    payment_state              varchar,
    email                      varchar,
    special_instructions       text,
    created_at                 timestamp,
    updated_at                 timestamp,
    currency                   varchar,
    last_ip_address            varchar,
    created_by_id              integer,
    shipment_total             numeric(20, 5) default 0.0                                      not null,
    additional_tax_total       numeric(20, 5) default 0.0,
    promo_total                numeric(20, 5) default 0.0,
    channel                    varchar        default 'spree'::character varying,
    included_tax_total         numeric(20, 5) default 0.0                                      not null,
    item_count                 integer        default 0,
    approver_id                integer,
    approved_at                timestamp,
    confirmation_delivered     boolean        default false,
    guest_token                varchar,
    canceled_at                timestamp,
    canceler_id                integer,
    store_id                   integer,
    approver_name              varchar,
    frontend_viewable          boolean        default true                                     not null,
    replace_product            boolean        default true,
    supermarket_id             integer,
    delivery_method            varchar,
    locale                     varchar,
    payment_amount_received    numeric(20, 5),
    auto_approved              boolean        default false,
    rescheduled                boolean        default false,
    magerecord_order_entity_id integer,
    offline_invoice_number     varchar,
    is_cartonization_enabled   boolean        default false                                    not null,
    express                    boolean        default false,
    meta                       jsonb          default '{}'::jsonb,
    palace                     boolean        default false,
    is_subscription            boolean        default false                                    not null,
    parent_id                  bigint
        constraint fk_rails_4917085921
            references spree_orders
            on delete cascade,
    vat_percentage             numeric(8, 2)  default 15.0                                     not null
);

create table danube_slot_to_orders
(
    id                       integer default nextval('danube_slot_to_orders_id_seq'::regclass) not null
        primary key,
    time_slots_schedule_id   integer,
    order_id                 integer
        constraint fk_rails_5eb4299703
            references spree_orders
            on delete cascade,
    time_slot_date           date,
    created_at               timestamp                                                         not null,
    updated_at               timestamp                                                         not null,
    start_time               time,
    end_time                 time,
    spree_zone_id            integer,
    spree_shipping_method_id integer
);

create index index_danube_slot_to_orders_on_order_id
    on danube_slot_to_orders (order_id);

create index index_danube_slot_to_orders_on_time_slots_schedule_id
    on danube_slot_to_orders (time_slots_schedule_id);

create index index_danube_slot_to_orders_on_spree_zone_id
    on danube_slot_to_orders (spree_zone_id);

create index index_danube_slot_to_orders_on_spree_shipping_method_id
    on danube_slot_to_orders (spree_shipping_method_id);

create index index_danube_slot_to_orders_on_start_time
    on danube_slot_to_orders (start_time);

create index index_danube_slot_to_orders_on_end_time
    on danube_slot_to_orders (end_time);

create index index_danube_slot_to_orders_on_time_slot_date
    on danube_slot_to_orders (time_slot_date);

create table spree_adjustments
(
    id                   integer default nextval('spree_adjustments_id_seq'::regclass) not null
        primary key,
    source_type          varchar,
    source_id            integer,
    adjustable_type      varchar,
    adjustable_id        integer                                                       not null,
    amount               numeric(20, 5)                                                not null,
    label                varchar,
    eligible             boolean default true,
    created_at           timestamp,
    updated_at           timestamp,
    order_id             integer                                                       not null
        constraint fk_spree_adjustments_order_id
            references spree_orders
            on update restrict on delete restrict,
    included             boolean default false,
    promotion_code_id    integer,
    adjustment_reason_id integer,
    finalized            boolean default false                                         not null,
    free_sample          boolean default false,
    constraint check_spree_adjustments_order_id
        check (((adjustable_type)::text <> 'Spree::Order'::text) OR (order_id = adjustable_id))
);

create index index_adjustments_on_order_id
    on spree_adjustments (adjustable_id);

create index index_spree_adjustments_on_adjustable_id_and_adjustable_type
    on spree_adjustments (adjustable_id, adjustable_type);

create index index_spree_adjustments_on_eligible
    on spree_adjustments (eligible);

create index index_spree_adjustments_on_order_id
    on spree_adjustments (order_id);

create index index_spree_adjustments_on_promotion_code_id
    on spree_adjustments (promotion_code_id);

create index index_spree_adjustments_on_source_id_and_source_type
    on spree_adjustments (source_id, source_type);

create index index_spree_orders_on_approver_id
    on spree_orders (approver_id);

create index index_spree_orders_on_bill_address_id
    on spree_orders (bill_address_id);

create index index_spree_orders_on_completed_at
    on spree_orders (completed_at);

create index index_spree_orders_on_created_by_id
    on spree_orders (created_by_id);

create index index_spree_orders_on_guest_token
    on spree_orders (guest_token);

create index index_spree_orders_on_ship_address_id
    on spree_orders (ship_address_id);

create index index_spree_orders_on_user_id
    on spree_orders (user_id);

create index index_spree_orders_on_user_id_and_created_by_id
    on spree_orders (user_id, created_by_id);

create index index_spree_orders_on_offline_invoice_number
    on spree_orders (offline_invoice_number);

create index index_spree_orders_on_created_at
    on spree_orders (created_at);

create index index_spree_orders_on_number
    on spree_orders (number);

create index index_spree_orders_on_parent_id
    on spree_orders (parent_id);

create table spree_orders_promotions
(
    order_id          integer,
    promotion_id      integer,
    promotion_code_id integer,
    id                integer default nextval('spree_orders_promotions_id_seq'::regclass) not null
        primary key,
    created_at        timestamp,
    updated_at        timestamp
);

create index index_spree_orders_promotions_on_order_id_and_promotion_id
    on spree_orders_promotions (order_id, promotion_id);

create index index_spree_orders_promotions_on_promotion_code_id
    on spree_orders_promotions (promotion_code_id);

create table spree_pages
(
    id                       integer default nextval('spree_pages_id_seq'::regclass) not null
        primary key,
    title                    varchar,
    body                     text,
    slug                     varchar,
    created_at               timestamp,
    updated_at               timestamp,
    show_in_header           boolean default false                                   not null,
    show_in_footer           boolean default false                                   not null,
    foreign_link             varchar,
    position                 integer default 1                                       not null,
    visible                  boolean default true,
    meta_keywords            varchar,
    meta_description         varchar,
    layout                   varchar,
    show_in_sidebar          boolean default false                                   not null,
    meta_title               varchar,
    render_layout_as_partial boolean default false
);

create index index_spree_pages_on_slug
    on spree_pages (slug);

create table spree_pages_stores
(
    store_id   integer,
    page_id    integer,
    created_at timestamp,
    updated_at timestamp
);

create index index_spree_pages_stores_on_page_id
    on spree_pages_stores (page_id);

create index index_spree_pages_stores_on_store_id
    on spree_pages_stores (store_id);

create table spree_payment_capture_events
(
    id         integer        default nextval('spree_payment_capture_events_id_seq'::regclass) not null
        primary key,
    amount     numeric(20, 5) default 0.0,
    payment_id integer,
    created_at timestamp,
    updated_at timestamp
);

create index index_spree_payment_capture_events_on_payment_id
    on spree_payment_capture_events (payment_id);

create table spree_payment_method_translations
(
    id                      integer default nextval('spree_payment_method_translations_id_seq'::regclass) not null
        primary key,
    spree_payment_method_id integer                                                                       not null,
    locale                  varchar                                                                       not null,
    created_at              timestamp                                                                     not null,
    updated_at              timestamp                                                                     not null,
    name                    varchar,
    description             varchar
);

create index index_54e08b997873be9e89e0569bcd4bc61162b94ed3
    on spree_payment_method_translations (spree_payment_method_id);

create index index_spree_payment_method_translations_on_locale
    on spree_payment_method_translations (locale);

create table spree_payment_methods
(
    id                 integer default nextval('spree_payment_methods_id_seq'::regclass) not null
        primary key,
    type               varchar,
    name               varchar,
    description        text,
    active             boolean default true,
    deleted_at         timestamp,
    created_at         timestamp,
    updated_at         timestamp,
    auto_capture       boolean,
    preferences        text,
    preference_source  varchar,
    position           integer default 0,
    available_to_users boolean default true,
    available_to_admin boolean default true
);

create index index_spree_payment_methods_on_id_and_type
    on spree_payment_methods (id, type);

create table spree_payments
(
    id                   integer        default nextval('spree_payments_id_seq'::regclass) not null
        primary key,
    amount               numeric(20, 5) default 0.0                                        not null,
    order_id             integer,
    source_type          varchar,
    source_id            integer,
    payment_method_id    integer,
    state                varchar,
    response_code        varchar,
    avs_response         varchar,
    created_at           timestamp,
    updated_at           timestamp,
    number               varchar,
    cvv_response_code    varchar,
    cvv_response_message varchar,
    meta                 jsonb          default '{}'::jsonb,
    child_order_id       bigint
        constraint fk_rails_cdeafc3daf
            references spree_orders
            on delete cascade
);

create index index_spree_payments_on_order_id
    on spree_payments (order_id);

create index index_spree_payments_on_payment_method_id
    on spree_payments (payment_method_id);

create index index_spree_payments_on_source_id_and_source_type
    on spree_payments (source_id, source_type);

create index index_spree_payments_on_state
    on spree_payments (state);

create index index_spree_payments_on_child_order_id
    on spree_payments (child_order_id);

create table spree_preferences
(
    id         integer default nextval('spree_preferences_id_seq'::regclass) not null
        primary key,
    value      text,
    key        varchar,
    created_at timestamp,
    updated_at timestamp
);

create unique index index_spree_preferences_on_key
    on spree_preferences (key);

create table spree_prices
(
    id          integer default nextval('spree_prices_id_seq'::regclass) not null
        primary key,
    variant_id  integer                                                  not null,
    amount      numeric(20, 5),
    currency    varchar,
    deleted_at  timestamp,
    created_at  timestamp,
    updated_at  timestamp,
    country_iso varchar(2)
);

create index index_spree_prices_on_country_iso
    on spree_prices (country_iso);

create index index_spree_prices_on_variant_id_and_currency
    on spree_prices (variant_id, currency);

create table spree_product_option_types
(
    id             integer default nextval('spree_product_option_types_id_seq'::regclass) not null
        primary key,
    position       integer,
    product_id     integer,
    option_type_id integer,
    created_at     timestamp,
    updated_at     timestamp
);

create index index_spree_product_option_types_on_option_type_id
    on spree_product_option_types (option_type_id);

create index index_spree_product_option_types_on_position
    on spree_product_option_types (position);

create index index_spree_product_option_types_on_product_id
    on spree_product_option_types (product_id);

create table spree_product_properties
(
    id          integer default nextval('spree_product_properties_id_seq'::regclass) not null
        primary key,
    value       varchar,
    product_id  integer,
    property_id integer,
    created_at  timestamp,
    updated_at  timestamp,
    position    integer default 0
);

create index index_product_properties_on_product_id
    on spree_product_properties (product_id);

create index index_spree_product_properties_on_position
    on spree_product_properties (position);

create index index_spree_product_properties_on_property_id
    on spree_product_properties (property_id);

create table spree_product_property_translations
(
    id                        integer default nextval('spree_product_property_translations_id_seq'::regclass) not null
        primary key,
    spree_product_property_id integer                                                                         not null,
    locale                    varchar                                                                         not null,
    created_at                timestamp                                                                       not null,
    updated_at                timestamp                                                                       not null,
    value                     varchar
);

create index index_0968f57fbd8fb9f31050820cbb66109a266c516a
    on spree_product_property_translations (spree_product_property_id);

create index index_spree_product_property_translations_on_locale
    on spree_product_property_translations (locale);

create table spree_product_translations
(
    id                  integer default nextval('spree_product_translations_id_seq'::regclass) not null
        primary key,
    spree_product_id    integer                                                                not null,
    locale              varchar                                                                not null,
    created_at          timestamp                                                              not null,
    updated_at          timestamp                                                              not null,
    name                varchar,
    description         text,
    meta_description    varchar,
    meta_keywords       varchar,
    slug                varchar,
    deleted_at          timestamp,
    validity_tag        varchar,
    package_description varchar,
    manufacturer        varchar,
    pack_size           varchar,
    pack_unit           varchar,
    full_name           varchar
);

create index index_spree_product_translations_on_deleted_at
    on spree_product_translations (deleted_at);

create index index_spree_product_translations_on_locale
    on spree_product_translations (locale);

create index index_spree_product_translations_on_spree_product_id
    on spree_product_translations (spree_product_id);

create table spree_products_taxons
(
    product_id integer,
    taxon_id   integer,
    id         integer default nextval('spree_products_taxons_id_seq'::regclass) not null
        primary key,
    position   integer,
    created_at timestamp,
    updated_at timestamp
);

create index index_spree_products_taxons_on_position
    on spree_products_taxons (position);

create index index_spree_products_taxons_on_product_id
    on spree_products_taxons (product_id);

create index index_spree_products_taxons_on_taxon_id
    on spree_products_taxons (taxon_id);

create table spree_promotion_action_line_items
(
    id                  integer default nextval('spree_promotion_action_line_items_id_seq'::regclass) not null
        primary key,
    promotion_action_id integer,
    variant_id          integer,
    quantity            integer default 1,
    created_at          timestamp,
    updated_at          timestamp
);

create index index_spree_promotion_action_line_items_on_promotion_action_id
    on spree_promotion_action_line_items (promotion_action_id);

create index index_spree_promotion_action_line_items_on_variant_id
    on spree_promotion_action_line_items (variant_id);

create table spree_promotion_actions
(
    id           integer default nextval('spree_promotion_actions_id_seq'::regclass) not null
        primary key,
    promotion_id integer,
    position     integer,
    type         varchar,
    deleted_at   timestamp,
    preferences  text,
    created_at   timestamp,
    updated_at   timestamp
);

create index index_spree_promotion_actions_on_deleted_at
    on spree_promotion_actions (deleted_at);

create index index_spree_promotion_actions_on_id_and_type
    on spree_promotion_actions (id, type);

create index index_spree_promotion_actions_on_promotion_id
    on spree_promotion_actions (promotion_id);

create table spree_promotion_categories
(
    id         integer default nextval('spree_promotion_categories_id_seq'::regclass) not null
        primary key,
    name       varchar,
    created_at timestamp,
    updated_at timestamp,
    code       varchar
);

create table spree_promotion_codes
(
    id           integer default nextval('spree_promotion_codes_id_seq'::regclass) not null
        primary key,
    promotion_id integer                                                           not null,
    value        varchar                                                           not null,
    created_at   timestamp,
    updated_at   timestamp,
    value_arabic varchar
);

create index index_spree_promotion_codes_on_promotion_id
    on spree_promotion_codes (promotion_id);

create unique index index_spree_promotion_codes_on_value
    on spree_promotion_codes (value);

create table spree_promotion_rule_taxons
(
    id                integer default nextval('spree_promotion_rule_taxons_id_seq'::regclass) not null
        primary key,
    taxon_id          integer,
    promotion_rule_id integer,
    created_at        timestamp,
    updated_at        timestamp
);

create index index_spree_promotion_rule_taxons_on_promotion_rule_id
    on spree_promotion_rule_taxons (promotion_rule_id);

create index index_spree_promotion_rule_taxons_on_taxon_id
    on spree_promotion_rule_taxons (taxon_id);

create table spree_promotion_rules
(
    id               integer default nextval('spree_promotion_rules_id_seq'::regclass) not null
        primary key,
    promotion_id     integer,
    product_group_id integer,
    type             varchar,
    created_at       timestamp,
    updated_at       timestamp,
    code             varchar,
    preferences      text
);

create index index_promotion_rules_on_product_group_id
    on spree_promotion_rules (product_group_id);

create index index_spree_promotion_rules_on_promotion_id
    on spree_promotion_rules (promotion_id);

create table spree_promotion_rules_users
(
    user_id           integer,
    promotion_rule_id integer,
    id                integer default nextval('spree_promotion_rules_users_id_seq'::regclass) not null
        primary key,
    created_at        timestamp,
    updated_at        timestamp
);

create index index_promotion_rules_users_on_promotion_rule_id
    on spree_promotion_rules_users (promotion_rule_id);

create index index_promotion_rules_users_on_user_id
    on spree_promotion_rules_users (user_id);

create table spree_promotion_translations
(
    id                 integer default nextval('spree_promotion_translations_id_seq'::regclass) not null
        primary key,
    spree_promotion_id integer                                                                  not null,
    locale             varchar                                                                  not null,
    created_at         timestamp                                                                not null,
    updated_at         timestamp                                                                not null,
    name               varchar,
    description        varchar
);

create index index_spree_promotion_translations_on_locale
    on spree_promotion_translations (locale);

create index index_spree_promotion_translations_on_spree_promotion_id
    on spree_promotion_translations (spree_promotion_id);

create table spree_promotions
(
    id                    integer default nextval('spree_promotions_id_seq'::regclass) not null
        primary key,
    description           varchar,
    expires_at            timestamp,
    starts_at             timestamp,
    name                  varchar,
    type                  varchar,
    usage_limit           integer,
    match_policy          varchar default 'all'::character varying,
    code                  varchar,
    advertise             boolean default false,
    path                  varchar,
    created_at            timestamp,
    updated_at            timestamp,
    promotion_category_id integer,
    per_code_usage_limit  integer,
    apply_automatically   boolean default false,
    deleted_at            timestamp
);

create index index_spree_promotions_on_advertise
    on spree_promotions (advertise);

create index index_spree_promotions_on_apply_automatically
    on spree_promotions (apply_automatically);

create index index_spree_promotions_on_code
    on spree_promotions (code);

create index index_spree_promotions_on_expires_at
    on spree_promotions (expires_at);

create index index_spree_promotions_on_id_and_type
    on spree_promotions (id, type);

create index index_spree_promotions_on_promotion_category_id
    on spree_promotions (promotion_category_id);

create index index_spree_promotions_on_starts_at
    on spree_promotions (starts_at);

create index index_spree_promotions_on_deleted_at
    on spree_promotions (deleted_at);

create table spree_properties
(
    id           integer default nextval('spree_properties_id_seq'::regclass) not null
        primary key,
    name         varchar,
    presentation varchar,
    created_at   timestamp,
    updated_at   timestamp
);

create table spree_property_prototypes
(
    prototype_id integer,
    property_id  integer,
    id           integer default nextval('spree_property_prototypes_id_seq'::regclass) not null
        primary key,
    created_at   timestamp,
    updated_at   timestamp
);

create table spree_property_translations
(
    id                integer default nextval('spree_property_translations_id_seq'::regclass) not null
        primary key,
    spree_property_id integer                                                                 not null,
    locale            varchar                                                                 not null,
    created_at        timestamp                                                               not null,
    updated_at        timestamp                                                               not null,
    name              varchar,
    presentation      varchar
);

create index index_spree_property_translations_on_locale
    on spree_property_translations (locale);

create index index_spree_property_translations_on_spree_property_id
    on spree_property_translations (spree_property_id);

create table spree_prototypes
(
    id         integer default nextval('spree_prototypes_id_seq'::regclass) not null
        primary key,
    name       varchar,
    created_at timestamp,
    updated_at timestamp
);

create table spree_refund_reasons
(
    id         integer default nextval('spree_refund_reasons_id_seq'::regclass) not null
        primary key,
    name       varchar,
    active     boolean default true,
    mutable    boolean default true,
    created_at timestamp,
    updated_at timestamp,
    code       varchar
);

create table spree_refunds
(
    id               integer        default nextval('spree_refunds_id_seq'::regclass) not null
        primary key,
    payment_id       integer,
    amount           numeric(20, 5) default 0.0                                       not null,
    transaction_id   varchar,
    created_at       timestamp,
    updated_at       timestamp,
    refund_reason_id integer,
    reimbursement_id integer,
    status           varchar,
    response_code    varchar
);

create index index_refunds_on_refund_reason_id
    on spree_refunds (refund_reason_id);

create index index_spree_refunds_on_payment_id
    on spree_refunds (payment_id);

create index index_spree_refunds_on_reimbursement_id
    on spree_refunds (reimbursement_id);

create table spree_reimbursement_credits
(
    id               integer        default nextval('spree_reimbursement_credits_id_seq'::regclass) not null
        primary key,
    amount           numeric(20, 5) default 0.0                                                     not null,
    reimbursement_id integer,
    creditable_id    integer,
    creditable_type  varchar,
    created_at       timestamp,
    updated_at       timestamp
);

create table spree_reimbursement_types
(
    id         integer default nextval('spree_reimbursement_types_id_seq'::regclass) not null
        primary key,
    name       varchar,
    active     boolean default true,
    mutable    boolean default true,
    created_at timestamp,
    updated_at timestamp,
    type       varchar
);

create index index_spree_reimbursement_types_on_type
    on spree_reimbursement_types (type);

create table spree_reimbursements
(
    id                   integer default nextval('spree_reimbursements_id_seq'::regclass) not null
        primary key,
    number               varchar,
    reimbursement_status varchar,
    customer_return_id   integer,
    order_id             integer,
    total                numeric(20, 5),
    created_at           timestamp,
    updated_at           timestamp
);

create index index_spree_reimbursements_on_customer_return_id
    on spree_reimbursements (customer_return_id);

create index index_spree_reimbursements_on_order_id
    on spree_reimbursements (order_id);

create table spree_relation_types
(
    id          integer default nextval('spree_relation_types_id_seq'::regclass) not null
        primary key,
    name        varchar,
    description text,
    applies_to  varchar,
    created_at  timestamp,
    updated_at  timestamp
);

create table spree_relations
(
    id               integer        default nextval('spree_relations_id_seq'::regclass) not null
        primary key,
    relation_type_id integer,
    relatable_type   varchar,
    relatable_id     integer,
    related_to_type  varchar,
    related_to_id    integer,
    created_at       timestamp,
    updated_at       timestamp,
    discount_amount  numeric(20, 5) default 0.0,
    position         integer
);

create table spree_return_authorizations
(
    id                integer default nextval('spree_return_authorizations_id_seq'::regclass) not null
        primary key,
    number            varchar,
    state             varchar,
    order_id          integer,
    memo              text,
    created_at        timestamp,
    updated_at        timestamp,
    stock_location_id integer,
    return_reason_id  integer
);

create index index_return_authorizations_on_return_authorization_reason_id
    on spree_return_authorizations (return_reason_id);

create table spree_return_items
(
    id                              integer        default nextval('spree_return_items_id_seq'::regclass) not null
        primary key,
    return_authorization_id         integer,
    inventory_unit_id               integer,
    exchange_variant_id             integer,
    created_at                      timestamp,
    updated_at                      timestamp,
    amount                          numeric(20, 5) default 0.0                                            not null,
    included_tax_total              numeric(20, 5) default 0.0                                            not null,
    additional_tax_total            numeric(20, 5) default 0.0                                            not null,
    reception_status                varchar,
    acceptance_status               varchar,
    customer_return_id              integer,
    reimbursement_id                integer,
    exchange_inventory_unit_id      integer,
    acceptance_status_errors        text,
    preferred_reimbursement_type_id integer,
    override_reimbursement_type_id  integer,
    resellable                      boolean        default true                                           not null,
    return_reason_id                integer
);

create index index_return_items_on_customer_return_id
    on spree_return_items (customer_return_id);

create index index_spree_return_items_on_exchange_inventory_unit_id
    on spree_return_items (exchange_inventory_unit_id);

create table spree_return_reasons
(
    id         integer default nextval('spree_return_reasons_id_seq'::regclass) not null
        primary key,
    name       varchar,
    active     boolean default true,
    mutable    boolean default true,
    created_at timestamp,
    updated_at timestamp
);

create table spree_reviews
(
    id              integer default nextval('spree_reviews_id_seq'::regclass) not null
        primary key,
    product_id      integer,
    name            varchar,
    location        varchar,
    rating          integer,
    title           text,
    review          text,
    approved        boolean default false,
    created_at      timestamp,
    updated_at      timestamp,
    user_id         integer,
    ip_address      varchar,
    locale          varchar default 'en'::character varying,
    show_identifier boolean default true
);

create index index_spree_reviews_on_show_identifier
    on spree_reviews (show_identifier);

create table spree_roles
(
    id         integer default nextval('spree_roles_id_seq'::regclass) not null
        primary key,
    name       varchar,
    created_at timestamp,
    updated_at timestamp
);

create table spree_roles_users
(
    role_id    integer,
    user_id    integer,
    id         integer default nextval('spree_roles_users_id_seq'::regclass) not null
        primary key,
    created_at timestamp,
    updated_at timestamp
);

create index index_spree_roles_users_on_role_id
    on spree_roles_users (role_id);

create index index_spree_roles_users_on_user_id
    on spree_roles_users (user_id);

create table spree_shipments
(
    id                    integer        default nextval('spree_shipments_id_seq'::regclass) not null
        primary key,
    tracking              varchar,
    number                varchar,
    cost                  numeric(20, 5) default 0.0,
    shipped_at            timestamp,
    order_id              integer,
    deprecated_address_id integer,
    state                 varchar,
    created_at            timestamp,
    updated_at            timestamp,
    stock_location_id     integer,
    adjustment_total      numeric(20, 5) default 0.0,
    additional_tax_total  numeric(20, 5) default 0.0,
    promo_total           numeric(20, 5) default 0.0,
    included_tax_total    numeric(20, 5) default 0.0                                         not null
);

create index index_shipments_on_number
    on spree_shipments (number);

create index index_spree_shipments_on_deprecated_address_id
    on spree_shipments (deprecated_address_id);

create index index_spree_shipments_on_order_id
    on spree_shipments (order_id);

create index index_spree_shipments_on_stock_location_id
    on spree_shipments (stock_location_id);

create table spree_shipping_categories
(
    id         integer default nextval('spree_shipping_categories_id_seq'::regclass) not null
        primary key,
    name       varchar,
    created_at timestamp,
    updated_at timestamp
);

create table spree_shipping_method_categories
(
    id                   integer default nextval('spree_shipping_method_categories_id_seq'::regclass) not null
        primary key,
    shipping_method_id   integer                                                                      not null,
    shipping_category_id integer                                                                      not null,
    created_at           timestamp,
    updated_at           timestamp
);

create index index_spree_shipping_method_categories_on_shipping_method_id
    on spree_shipping_method_categories (shipping_method_id);

create unique index unique_spree_shipping_method_categories
    on spree_shipping_method_categories (shipping_category_id, shipping_method_id);

create table spree_shipping_method_translations
(
    id                       integer default nextval('spree_shipping_method_translations_id_seq'::regclass) not null
        primary key,
    spree_shipping_method_id integer                                                                        not null,
    locale                   varchar                                                                        not null,
    created_at               timestamp                                                                      not null,
    updated_at               timestamp                                                                      not null,
    name                     varchar
);

create index index_c713dce023452222dbb97ceedfc9eddb4f02a87f
    on spree_shipping_method_translations (spree_shipping_method_id);

create index index_spree_shipping_method_translations_on_locale
    on spree_shipping_method_translations (locale);

create table spree_shipping_method_zones
(
    shipping_method_id integer,
    zone_id            integer,
    id                 integer default nextval('spree_shipping_method_zones_id_seq'::regclass) not null
        primary key,
    created_at         timestamp,
    updated_at         timestamp
);

create index index_spree_shipping_method_zones_on_zone_id
    on spree_shipping_method_zones (zone_id);

create index index_spree_shipping_method_zones_on_shipping_method_id
    on spree_shipping_method_zones (shipping_method_id);

create table spree_shipping_methods
(
    id                 integer default nextval('spree_shipping_methods_id_seq'::regclass) not null
        primary key,
    name               varchar,
    deleted_at         timestamp,
    created_at         timestamp,
    updated_at         timestamp,
    tracking_url       varchar,
    admin_name         varchar,
    tax_category_id    integer,
    code               varchar,
    available_to_all   boolean default true,
    carrier            varchar,
    service_level      varchar,
    available_to_users boolean default true,
    time_offset        integer default 0
);

create index index_spree_shipping_methods_on_tax_category_id
    on spree_shipping_methods (tax_category_id);

create table spree_shipping_rate_taxes
(
    id               integer        default nextval('spree_shipping_rate_taxes_id_seq'::regclass) not null
        primary key,
    amount           numeric(20, 5) default 0.0                                                   not null,
    tax_rate_id      integer,
    shipping_rate_id integer,
    created_at       timestamp                                                                    not null,
    updated_at       timestamp                                                                    not null
);

create index index_spree_shipping_rate_taxes_on_shipping_rate_id
    on spree_shipping_rate_taxes (shipping_rate_id);

create index index_spree_shipping_rate_taxes_on_tax_rate_id
    on spree_shipping_rate_taxes (tax_rate_id);

create table spree_shipping_rates
(
    id                 integer        default nextval('spree_shipping_rates_id_seq'::regclass) not null
        primary key,
    shipment_id        integer,
    shipping_method_id integer,
    selected           boolean        default false,
    cost               numeric(20, 5) default 0.0,
    created_at         timestamp,
    updated_at         timestamp,
    tax_rate_id        integer
);

create unique index spree_shipping_rates_join_index
    on spree_shipping_rates (shipment_id, shipping_method_id);

create table spree_state_changes
(
    id             integer default nextval('spree_state_changes_id_seq'::regclass) not null
        primary key,
    name           varchar,
    previous_state varchar,
    stateful_id    integer,
    user_id        integer,
    stateful_type  varchar,
    next_state     varchar,
    created_at     timestamp,
    updated_at     timestamp
);

create index index_spree_state_changes_on_stateful_id_and_stateful_type
    on spree_state_changes (stateful_id, stateful_type);

create index index_spree_state_changes_on_user_id
    on spree_state_changes (user_id);

create table spree_state_translations
(
    id             integer default nextval('spree_state_translations_id_seq'::regclass) not null
        primary key,
    spree_state_id integer                                                              not null,
    locale         varchar                                                              not null,
    created_at     timestamp                                                            not null,
    updated_at     timestamp                                                            not null,
    name           varchar,
    abbr           varchar
);

create index index_spree_state_translations_on_locale
    on spree_state_translations (locale);

create index index_spree_state_translations_on_spree_state_id
    on spree_state_translations (spree_state_id);

create table spree_states
(
    id                 integer default nextval('spree_states_id_seq'::regclass) not null
        primary key,
    name               varchar,
    abbr               varchar,
    country_id         integer,
    updated_at         timestamp,
    created_at         timestamp,
    image_file_name    varchar,
    image_content_type varchar,
    image_file_size    integer,
    image_updated_at   timestamp
);

create index index_spree_states_on_country_id
    on spree_states (country_id);

create table spree_stock_items
(
    id                integer default nextval('spree_stock_items_id_seq'::regclass) not null
        primary key,
    stock_location_id integer,
    variant_id        integer,
    count_on_hand     integer default 0                                             not null,
    created_at        timestamp,
    updated_at        timestamp,
    backorderable     boolean default false,
    deleted_at        timestamp
);

create index index_spree_stock_items_on_deleted_at
    on spree_stock_items (deleted_at);

create index index_spree_stock_items_on_stock_location_id
    on spree_stock_items (stock_location_id);

create unique index index_spree_stock_items_on_variant_id_and_stock_location_id
    on spree_stock_items (variant_id, stock_location_id)
    where (deleted_at IS NULL);

create index stock_item_by_loc_and_var_id
    on spree_stock_items (stock_location_id, variant_id);

create table spree_stock_locations
(
    id                      integer default nextval('spree_stock_locations_id_seq'::regclass) not null
        primary key,
    name                    varchar,
    created_at              timestamp,
    updated_at              timestamp,
    "default"               boolean default false                                             not null,
    address1                varchar,
    address2                varchar,
    city                    varchar,
    state_id                integer,
    state_name              varchar,
    country_id              integer,
    zipcode                 varchar,
    phone                   varchar,
    active                  boolean default true,
    backorderable_default   boolean default false,
    propagate_all_variants  boolean default true,
    admin_name              varchar,
    position                integer default 0,
    restock_inventory       boolean default true                                              not null,
    fulfillable             boolean default true                                              not null,
    code                    varchar,
    check_stock_on_transfer boolean default true
);

create table spree_shipping_method_stock_locations
(
    id                 integer default nextval('spree_shipping_method_stock_locations_id_seq'::regclass) not null
        primary key,
    shipping_method_id integer
        constraint fk_rails_bf4245c753
            references spree_shipping_methods,
    stock_location_id  integer
        constraint fk_rails_5f722a205b
            references spree_stock_locations,
    created_at         timestamp,
    updated_at         timestamp
);

create index shipping_method_id_spree_sm_sl
    on spree_shipping_method_stock_locations (shipping_method_id);

create index sstock_location_id_spree_sm_sl
    on spree_shipping_method_stock_locations (stock_location_id);

create index index_spree_stock_locations_on_country_id
    on spree_stock_locations (country_id);

create index index_spree_stock_locations_on_state_id
    on spree_stock_locations (state_id);

create table spree_stock_movements
(
    id              integer default nextval('spree_stock_movements_id_seq'::regclass) not null
        primary key,
    stock_item_id   integer,
    quantity        integer default 0,
    action          varchar,
    created_at      timestamp                                                         not null,
    updated_at      timestamp                                                         not null,
    originator_type varchar,
    originator_id   integer
);

create index index_spree_stock_movements_on_stock_item_id
    on spree_stock_movements (stock_item_id);

create table spree_stock_transfers
(
    id                      integer default nextval('spree_stock_transfers_id_seq'::regclass) not null
        primary key,
    description             varchar,
    source_location_id      integer,
    destination_location_id integer,
    created_at              timestamp,
    updated_at              timestamp,
    number                  varchar,
    shipped_at              timestamp,
    closed_at               timestamp,
    tracking_number         varchar,
    created_by_id           integer,
    closed_by_id            integer,
    finalized_at            timestamp,
    finalized_by_id         integer,
    deleted_at              timestamp
);

create index index_spree_stock_transfers_on_closed_at
    on spree_stock_transfers (closed_at);

create index index_spree_stock_transfers_on_destination_location_id
    on spree_stock_transfers (destination_location_id);

create index index_spree_stock_transfers_on_finalized_at
    on spree_stock_transfers (finalized_at);

create index index_spree_stock_transfers_on_number
    on spree_stock_transfers (number);

create index index_spree_stock_transfers_on_shipped_at
    on spree_stock_transfers (shipped_at);

create index index_spree_stock_transfers_on_source_location_id
    on spree_stock_transfers (source_location_id);

create table spree_store_credit_categories
(
    id                 integer default nextval('spree_store_credit_categories_id_seq'::regclass) not null
        primary key,
    name               varchar,
    created_at         timestamp,
    updated_at         timestamp,
    available_to_admin boolean default false
);

create table spree_store_credit_events
(
    id                 integer        default nextval('spree_store_credit_events_id_seq'::regclass) not null
        primary key,
    store_credit_id    integer                                                                      not null,
    action             varchar                                                                      not null,
    amount             numeric(20, 5),
    user_total_amount  numeric(20, 5) default 0.0                                                   not null,
    authorization_code varchar                                                                      not null,
    deleted_at         timestamp,
    originator_type    varchar,
    originator_id      integer,
    created_at         timestamp,
    updated_at         timestamp,
    update_reason_id   integer,
    currency           varchar
);

create index index_spree_store_credit_events_on_deleted_at
    on spree_store_credit_events (deleted_at);

create index index_spree_store_credit_events_on_store_credit_id
    on spree_store_credit_events (store_credit_id);

create table spree_store_credit_types
(
    id         integer default nextval('spree_store_credit_types_id_seq'::regclass) not null
        primary key,
    name       varchar,
    priority   integer,
    created_at timestamp,
    updated_at timestamp
);

create index index_spree_store_credit_types_on_priority
    on spree_store_credit_types (priority);

create table spree_store_credit_update_reasons
(
    id         integer default nextval('spree_store_credit_update_reasons_id_seq'::regclass) not null
        primary key,
    name       varchar,
    created_at timestamp,
    updated_at timestamp
);

create table spree_store_credits
(
    id                  integer        default nextval('spree_store_credits_id_seq'::regclass) not null
        primary key,
    user_id             integer,
    category_id         integer,
    created_by_id       integer,
    amount              numeric(20, 5) default 0.0                                             not null,
    amount_used         numeric(20, 5) default 0.0                                             not null,
    amount_authorized   numeric(20, 5) default 0.0                                             not null,
    currency            varchar,
    memo                text,
    spree_store_credits timestamp,
    deleted_at          timestamp,
    created_at          timestamp,
    updated_at          timestamp,
    type_id             integer,
    invalidated_at      timestamp,
    expires_at          timestamp,
    meta                jsonb          default '{}'::jsonb
);

create index index_spree_store_credits_on_deleted_at
    on spree_store_credits (deleted_at);

create index index_spree_store_credits_on_type_id
    on spree_store_credits (type_id);

create index index_spree_store_credits_on_user_id
    on spree_store_credits (user_id);

create table spree_store_payment_methods
(
    id                integer default nextval('spree_store_payment_methods_id_seq'::regclass) not null
        primary key,
    store_id          integer                                                                 not null,
    payment_method_id integer                                                                 not null,
    created_at        timestamp                                                               not null,
    updated_at        timestamp                                                               not null
);

create index index_spree_store_payment_methods_on_payment_method_id
    on spree_store_payment_methods (payment_method_id);

create index index_spree_store_payment_methods_on_store_id
    on spree_store_payment_methods (store_id);

create table spree_store_translations
(
    id               integer default nextval('spree_store_translations_id_seq'::regclass) not null
        primary key,
    spree_store_id   integer                                                              not null,
    locale           varchar                                                              not null,
    created_at       timestamp                                                            not null,
    updated_at       timestamp                                                            not null,
    name             varchar,
    meta_description text,
    meta_keywords    text,
    seo_title        varchar
);

create index index_spree_store_translations_on_locale
    on spree_store_translations (locale);

create index index_spree_store_translations_on_spree_store_id
    on spree_store_translations (spree_store_id);

create table spree_stores
(
    id                         integer default nextval('spree_stores_id_seq'::regclass) not null
        primary key,
    name                       varchar,
    url                        varchar,
    meta_description           text,
    meta_keywords              text,
    seo_title                  varchar,
    mail_from_address          varchar,
    default_currency           varchar,
    code                       varchar,
    "default"                  boolean default false                                    not null,
    created_at                 timestamp,
    updated_at                 timestamp,
    cart_tax_country_iso       varchar,
    preferences                jsonb   default '{}'::jsonb,
    loyalty_settings           jsonb   default '{}'::jsonb,
    gift_card_settings         jsonb   default '{}'::jsonb,
    app_version_info           jsonb   default '{}'::jsonb,
    subscription_plan_settings jsonb   default '{}'::jsonb
);

create index index_spree_stores_on_code
    on spree_stores (code);

create index index_spree_stores_on_default
    on spree_stores ("default");

create table spree_tax_categories
(
    id          integer default nextval('spree_tax_categories_id_seq'::regclass) not null
        primary key,
    name        varchar,
    description varchar,
    is_default  boolean default false,
    deleted_at  timestamp,
    created_at  timestamp,
    updated_at  timestamp,
    tax_code    varchar
);

create table spree_tax_rates
(
    id                 integer default nextval('spree_tax_rates_id_seq'::regclass) not null
        primary key,
    amount             numeric(20, 5),
    zone_id            integer,
    tax_category_id    integer,
    included_in_price  boolean default false,
    created_at         timestamp,
    updated_at         timestamp,
    name               varchar,
    show_rate_in_label boolean default true,
    deleted_at         timestamp
);

create index index_spree_tax_rates_on_deleted_at
    on spree_tax_rates (deleted_at);

create index index_spree_tax_rates_on_tax_category_id
    on spree_tax_rates (tax_category_id);

create index index_spree_tax_rates_on_zone_id
    on spree_tax_rates (zone_id);

create table spree_taxon_group_memberships
(
    id             integer default nextval('spree_taxon_group_memberships_id_seq'::regclass) not null
        primary key,
    taxon_group_id integer,
    taxon_id       integer,
    position       integer default 0
);

create index index_spree_taxon_group_memberships_on_taxon_id
    on spree_taxon_group_memberships (taxon_id);

create index index_spree_taxon_group_memberships_on_taxon_group_id
    on spree_taxon_group_memberships (taxon_group_id);

create index index_spree_taxon_group_memberships_on_position
    on spree_taxon_group_memberships (position);

create table spree_taxon_groups
(
    id         integer default nextval('spree_taxon_groups_id_seq'::regclass) not null
        primary key,
    name       varchar,
    created_at timestamp                                                      not null,
    updated_at timestamp                                                      not null,
    key        varchar
);

create table spree_taxon_translations
(
    id               integer default nextval('spree_taxon_translations_id_seq'::regclass) not null
        primary key,
    spree_taxon_id   integer                                                              not null,
    locale           varchar                                                              not null,
    created_at       timestamp                                                            not null,
    updated_at       timestamp                                                            not null,
    name             varchar,
    description      text,
    meta_title       varchar,
    meta_description varchar,
    meta_keywords    varchar,
    permalink        varchar
);

create index index_spree_taxon_translations_on_locale
    on spree_taxon_translations (locale);

create index index_spree_taxon_translations_on_spree_taxon_id
    on spree_taxon_translations (spree_taxon_id);

create index index_spree_taxon_translations_on_name
    on spree_taxon_translations (name);

create table spree_taxonomies
(
    id         integer default nextval('spree_taxonomies_id_seq'::regclass) not null
        primary key,
    name       varchar,
    created_at timestamp,
    updated_at timestamp,
    position   integer default 0
);

create index index_spree_taxonomies_on_position
    on spree_taxonomies (position);

create table spree_taxonomy_translations
(
    id                integer default nextval('spree_taxonomy_translations_id_seq'::regclass) not null
        primary key,
    spree_taxonomy_id integer                                                                 not null,
    locale            varchar                                                                 not null,
    created_at        timestamp                                                               not null,
    updated_at        timestamp                                                               not null,
    name              varchar
);

create index index_spree_taxonomy_translations_on_locale
    on spree_taxonomy_translations (locale);

create index index_spree_taxonomy_translations_on_spree_taxonomy_id
    on spree_taxonomy_translations (spree_taxonomy_id);

create table spree_taxons
(
    id                                 integer default nextval('spree_taxons_id_seq'::regclass) not null
        primary key,
    parent_id                          integer,
    position                           integer default 0,
    name                               varchar,
    permalink                          varchar,
    taxonomy_id                        integer,
    lft                                integer,
    rgt                                integer,
    icon_file_name                     varchar,
    icon_content_type                  varchar,
    icon_file_size                     integer,
    icon_updated_at                    timestamp,
    description                        text,
    created_at                         timestamp,
    updated_at                         timestamp,
    meta_title                         varchar,
    meta_description                   varchar,
    meta_keywords                      varchar,
    depth                              integer,
    visible                            boolean default true,
    background_image_en_file_name      varchar,
    background_image_en_content_type   varchar,
    background_image_en_file_size      integer,
    background_image_en_updated_at     timestamp,
    home_background_image_file_name    varchar,
    home_background_image_content_type varchar,
    home_background_image_file_size    integer,
    home_background_image_updated_at   timestamp,
    background_image_ar_file_name      varchar,
    background_image_ar_content_type   varchar,
    background_image_ar_file_size      integer,
    background_image_ar_updated_at     timestamp,
    magerecord_category_entity_id      integer,
    magerecord_category_id             integer,
    start_time                         timestamp,
    end_time                           timestamp,
    scheduled_jobs                     jsonb,
    banner_en_file_name                varchar,
    banner_en_content_type             varchar,
    banner_en_file_size                integer,
    banner_en_updated_at               timestamp,
    banner_ar_file_name                varchar,
    banner_ar_content_type             varchar,
    banner_ar_file_size                integer,
    banner_ar_updated_at               timestamp,
    product_image_tag_en_file_name     varchar,
    product_image_tag_en_content_type  varchar,
    product_image_tag_en_file_size     integer,
    product_image_tag_en_updated_at    timestamp,
    product_image_tag_ar_file_name     varchar,
    product_image_tag_ar_content_type  varchar,
    product_image_tag_ar_file_size     integer,
    product_image_tag_ar_updated_at    timestamp,
    product_text_tag_en                varchar,
    product_text_tag_ar                varchar,
    tag_to_show                        varchar,
    visible_only_for_subscriber        boolean default false
);

create table spree_prototype_taxons
(
    id           integer default nextval('spree_prototype_taxons_id_seq'::regclass) not null
        primary key,
    taxon_id     integer
        constraint fk_rails_d3da4db5c5
            references spree_taxons,
    prototype_id integer
        constraint fk_rails_64c6b66d98
            references spree_prototypes,
    created_at   timestamp,
    updated_at   timestamp
);

create index index_spree_prototype_taxons_on_prototype_id
    on spree_prototype_taxons (prototype_id);

create index index_spree_prototype_taxons_on_taxon_id
    on spree_prototype_taxons (taxon_id);

create index index_spree_taxons_on_position
    on spree_taxons (position);

create index index_taxons_on_parent_id
    on spree_taxons (parent_id);

create index index_taxons_on_permalink
    on spree_taxons (permalink);

create index index_taxons_on_taxonomy_id
    on spree_taxons (taxonomy_id);

create table spree_trackers
(
    id           integer default nextval('spree_trackers_id_seq'::regclass) not null
        primary key,
    environment  varchar,
    analytics_id varchar,
    active       boolean default true,
    created_at   timestamp,
    updated_at   timestamp
);

create table spree_transfer_items
(
    id                integer default nextval('spree_transfer_items_id_seq'::regclass) not null
        primary key,
    variant_id        integer                                                          not null,
    stock_transfer_id integer                                                          not null,
    expected_quantity integer default 0                                                not null,
    received_quantity integer default 0                                                not null,
    created_at        timestamp,
    updated_at        timestamp,
    deleted_at        timestamp
);

create index index_spree_transfer_items_on_stock_transfer_id
    on spree_transfer_items (stock_transfer_id);

create index index_spree_transfer_items_on_variant_id
    on spree_transfer_items (variant_id);

create table spree_unit_cancels
(
    id                integer default nextval('spree_unit_cancels_id_seq'::regclass) not null
        primary key,
    inventory_unit_id integer                                                        not null,
    reason            varchar,
    created_by        varchar,
    created_at        timestamp,
    updated_at        timestamp
);

create index index_spree_unit_cancels_on_inventory_unit_id
    on spree_unit_cancels (inventory_unit_id);

create table spree_user_addresses
(
    id         integer default nextval('spree_user_addresses_id_seq'::regclass) not null
        primary key,
    user_id    integer                                                          not null,
    address_id integer                                                          not null,
    "default"  boolean default false,
    archived   boolean default false,
    created_at timestamp                                                        not null,
    updated_at timestamp                                                        not null
);

create index index_spree_user_addresses_on_address_id
    on spree_user_addresses (address_id);

create index index_spree_user_addresses_on_user_id
    on spree_user_addresses (user_id);

create unique index index_spree_user_addresses_on_user_id_and_address_id
    on spree_user_addresses (user_id, address_id);

create table spree_user_authentications
(
    id         integer default nextval('spree_user_authentications_id_seq'::regclass) not null
        primary key,
    user_id    integer,
    provider   varchar,
    uid        varchar,
    created_at timestamp,
    updated_at timestamp,
    meta       jsonb   default '{}'::jsonb
);

create index index_spree_user_authentications_on_user_id
    on spree_user_authentications (user_id);

create table spree_user_stock_locations
(
    id                integer default nextval('spree_user_stock_locations_id_seq'::regclass) not null
        primary key,
    user_id           integer,
    stock_location_id integer,
    created_at        timestamp,
    updated_at        timestamp
);

create index index_spree_user_stock_locations_on_user_id
    on spree_user_stock_locations (user_id);

create table spree_user_supermarkets
(
    id             integer default nextval('spree_user_supermarkets_id_seq'::regclass) not null
        primary key,
    user_id        integer,
    supermarket_id integer,
    created_at     timestamp                                                           not null,
    updated_at     timestamp                                                           not null
);

create index index_spree_user_supermarkets_on_user_id
    on spree_user_supermarkets (user_id);

create index index_spree_user_supermarkets_on_supermarket_id
    on spree_user_supermarkets (supermarket_id);

create table spree_users
(
    id                                  integer default nextval('spree_users_id_seq'::regclass) not null
        primary key,
    encrypted_password                  varchar(128),
    password_salt                       varchar(128),
    email                               varchar,
    remember_token                      varchar,
    persistence_token                   varchar,
    reset_password_token                varchar,
    perishable_token                    varchar,
    sign_in_count                       integer default 0                                       not null,
    failed_attempts                     integer default 0                                       not null,
    last_request_at                     timestamp,
    current_sign_in_at                  timestamp,
    last_sign_in_at                     timestamp,
    current_sign_in_ip                  varchar,
    last_sign_in_ip                     varchar,
    login                               varchar,
    ship_address_id                     integer,
    bill_address_id                     integer,
    authentication_token                varchar,
    unlock_token                        varchar,
    locked_at                           timestamp,
    reset_password_sent_at              timestamp,
    created_at                          timestamp,
    updated_at                          timestamp,
    spree_api_key                       varchar(48),
    remember_created_at                 timestamp,
    deleted_at                          timestamp,
    confirmation_token                  varchar,
    confirmed_at                        timestamp,
    confirmation_sent_at                timestamp,
    first_name                          varchar,
    last_name                           varchar,
    mobile_phone_number                 varchar,
    danube_communication_preference_id  integer
        constraint fk_rails_b76dcec921
            references danube_communication_preferences,
    marketing_communication             boolean default true,
    accept_terms_and_conditions         boolean default true,
    danube_salutation_id                integer
        constraint fk_rails_a788805338
            references danube_salutations,
    locale                              varchar,
    spree_api_platform                  varchar,
    blacklisted_at                      timestamp,
    blacklisted_reason                  varchar,
    last_notification_seen_at           timestamp,
    is_phone_verified                   boolean default false,
    delivery_method                     varchar,
    delivery_state_id                   integer,
    delivery_district_id                integer,
    delivery_supermarket_id             integer,
    freshdesk_contact_id                varchar,
    magerecord_auto_assigned_salutation boolean,
    magerecord_legacy_password_hash     varchar,
    magerecord_customer_entity_id       integer,
    referral_code                       varchar,
    loyalty_member_id                   integer,
    allow_activity_until                timestamp,
    palace                              boolean default false,
    dob                                 date,
    a_b_variant                         varchar default 'A'::character varying,
    mobile_number_country_code          varchar default '966'::character varying,
    loyalty_id                          varchar
);

create unique index email_idx_unique
    on spree_users (email);

create index index_spree_users_on_danube_communication_preference_id
    on spree_users (danube_communication_preference_id);

create index index_spree_users_on_danube_salutation_id
    on spree_users (danube_salutation_id);

create index index_spree_users_on_deleted_at
    on spree_users (deleted_at);

create index index_spree_users_on_spree_api_key
    on spree_users (spree_api_key);

create index index_spree_users_on_ship_address_id
    on spree_users (ship_address_id);

create index index_spree_users_on_bill_address_id
    on spree_users (bill_address_id);

create index index_spree_users_on_allow_activity_until
    on spree_users (allow_activity_until desc);

create unique index index_spree_users_on_loyalty_id
    on spree_users (loyalty_id);

create table spree_variant_property_rule_conditions
(
    id                       integer default nextval('spree_variant_property_rule_conditions_id_seq'::regclass) not null
        primary key,
    option_value_id          integer,
    variant_property_rule_id integer,
    created_at               timestamp                                                                          not null,
    updated_at               timestamp                                                                          not null
);

create index index_spree_variant_prop_rule_conditions_on_rule_and_optval
    on spree_variant_property_rule_conditions (variant_property_rule_id, option_value_id);

create table spree_variant_property_rule_values
(
    id                       integer default nextval('spree_variant_property_rule_values_id_seq'::regclass) not null
        primary key,
    value                    text,
    position                 integer default 0,
    property_id              integer,
    variant_property_rule_id integer,
    created_at               timestamp,
    updated_at               timestamp
);

create index index_spree_variant_property_rule_values_on_property_id
    on spree_variant_property_rule_values (property_id);

create index index_spree_variant_property_rule_values_on_rule
    on spree_variant_property_rule_values (variant_property_rule_id);

create table spree_variant_property_rules
(
    id         integer default nextval('spree_variant_property_rules_id_seq'::regclass) not null
        primary key,
    product_id integer,
    created_at timestamp                                                                not null,
    updated_at timestamp                                                                not null
);

create index index_spree_variant_property_rules_on_product_id
    on spree_variant_property_rules (product_id);

create table spree_variants
(
    id                          integer       default nextval('spree_variants_id_seq'::regclass) not null
        primary key,
    sku                         varchar       default ''::character varying                      not null,
    weight                      numeric(8, 2) default 0.0,
    height                      numeric(8, 2),
    width                       numeric(8, 2),
    depth                       numeric(8, 2),
    deleted_at                  timestamp,
    is_master                   boolean       default false,
    product_id                  integer,
    cost_price                  numeric(20, 5),
    position                    integer,
    cost_currency               varchar,
    track_inventory             boolean       default true,
    tax_category_id             integer,
    updated_at                  timestamp,
    created_at                  timestamp,
    perform_liquid_weight_check boolean       default false,
    max_weight_per_order        integer       default 5000,
    weight_increment            integer       default 0,
    default_weight_count        integer       default 1,
    to_be_cased                 boolean       default false,
    excluded_from_vat           boolean       default false
);

create index index_spree_variants_on_position
    on spree_variants (position);

create index index_spree_variants_on_product_id
    on spree_variants (product_id);

create index index_spree_variants_on_sku
    on spree_variants (sku);

create index index_spree_variants_on_tax_category_id
    on spree_variants (tax_category_id);

create index index_spree_variants_on_track_inventory
    on spree_variants (track_inventory);

create table spree_wished_products
(
    id          integer default nextval('spree_wished_products_id_seq'::regclass) not null
        primary key,
    variant_id  integer,
    wishlist_id integer,
    remark      text,
    created_at  timestamp                                                         not null,
    updated_at  timestamp                                                         not null,
    quantity    integer default 1                                                 not null
);

create index index_spree_wished_products_on_variant_id
    on spree_wished_products (variant_id);

create index index_spree_wished_products_on_wishlist_id
    on spree_wished_products (wishlist_id);

create table spree_wishlists
(
    id          integer default nextval('spree_wishlists_id_seq'::regclass) not null
        primary key,
    user_id     integer,
    name        varchar,
    access_hash varchar,
    is_private  boolean default true                                        not null,
    is_default  boolean default false                                       not null,
    created_at  timestamp                                                   not null,
    updated_at  timestamp                                                   not null
);

create index index_spree_wishlists_on_user_id
    on spree_wishlists (user_id);

create index index_spree_wishlists_on_user_id_and_is_default
    on spree_wishlists (user_id, is_default);

create table spree_zone_members
(
    id            integer default nextval('spree_zone_members_id_seq'::regclass) not null
        primary key,
    zoneable_type varchar,
    zoneable_id   integer,
    zone_id       integer,
    created_at    timestamp,
    updated_at    timestamp
);

create index index_spree_zone_members_on_zone_id
    on spree_zone_members (zone_id);

create index index_spree_zone_members_on_zoneable_id_and_zoneable_type
    on spree_zone_members (zoneable_id, zoneable_type);

create table spree_zones
(
    id                 integer default nextval('spree_zones_id_seq'::regclass) not null
        primary key,
    name               varchar,
    description        varchar,
    default_tax        boolean default false,
    zone_members_count integer default 0,
    created_at         timestamp,
    updated_at         timestamp
);

create table danube_time_slots_schedules
(
    id                          integer default nextval('danube_time_slots_schedules_id_seq'::regclass) not null
        primary key,
    zone_id                     integer
        constraint fk_rails_dfcf16c9a0
            references spree_zones,
    time_slot_id                integer
        constraint fk_rails_ac23701fd1
            references danube_time_slots,
    day_of_week                 integer,
    delivery_capacity           integer,
    created_at                  timestamp                                                               not null,
    updated_at                  timestamp                                                               not null,
    danube_slot_to_orders_count integer default 0,
    spree_shipping_method_id    integer
        constraint fk_rails_3d30756b17
            references spree_shipping_methods,
    enabled                     boolean default true,
    batch_creation_time         time,
    is_subscription             boolean default false                                                   not null
);

create index index_danube_time_slots_schedules_on_spree_shipping_method_id
    on danube_time_slots_schedules (spree_shipping_method_id);

create index index_danube_time_slots_schedules_on_time_slot_id
    on danube_time_slots_schedules (time_slot_id);

create index index_danube_time_slots_schedules_on_zone_id
    on danube_time_slots_schedules (zone_id);

create table versions
(
    id             integer default nextval('versions_id_seq'::regclass) not null
        primary key,
    item_type      varchar                                              not null,
    item_id        integer                                              not null,
    event          varchar                                              not null,
    whodunnit      varchar,
    created_at     timestamp,
    comments       varchar,
    date_of_action timestamp,
    whodunnit_type varchar default 'Spree::User'::character varying,
    object         jsonb,
    object_changes jsonb
);

create index index_versions_on_item_type_and_item_id
    on versions (item_type, item_id);

create index index_versions_on_whodunnit_type_and_whodunnit
    on versions (whodunnit_type, whodunnit)
    where (whodunnit IS NOT NULL);

create table danube_area_suggestions
(
    id         integer default nextval('danube_area_suggestions_id_seq'::regclass) not null
        primary key,
    city       varchar,
    area       varchar,
    email      varchar,
    created_at timestamp                                                           not null,
    updated_at timestamp                                                           not null,
    point      geography(Point, 4326)
);

create table spree_sale_prices
(
    id         integer default nextval('spree_sale_prices_id_seq'::regclass) not null
        primary key,
    price_id   integer,
    value      numeric(20, 5)                                                not null,
    start_at   timestamp,
    end_at     timestamp,
    enabled    boolean,
    created_at timestamp,
    updated_at timestamp
);

create index index_active_sale_prices_for_price
    on spree_sale_prices (price_id, start_at, end_at, enabled);

create index index_active_sale_prices_for_all_variants
    on spree_sale_prices (start_at, end_at, enabled);

create index index_sale_prices_for_price
    on spree_sale_prices (price_id);

create table spree_job_entities
(
    id             integer default nextval('spree_job_entities_id_seq'::regclass) not null
        primary key,
    class_name     varchar,
    state          varchar,
    started_at     timestamp,
    completed_at   timestamp,
    status_message varchar,
    input          jsonb,
    output         jsonb,
    created_at     timestamp                                                      not null,
    updated_at     timestamp                                                      not null
);

create table spree_drift_device_locations
(
    id           integer default nextval('spree_drift_device_locations_id_seq'::regclass) not null
        primary key,
    uuid         varchar,
    order_number varchar,
    latitude     double precision,
    longitude    double precision,
    created_at   timestamp                                                                not null,
    updated_at   timestamp                                                                not null
);

create table spatial_ref_sys
(
    srid      integer not null
        primary key
        constraint spatial_ref_sys_srid_check
            check ((srid > 0) AND (srid <= 998999)),
    auth_name varchar(256),
    auth_srid integer,
    srtext    varchar(2048),
    proj4text varchar(2048)
);

create table spree_custom_products
(
    id          integer default nextval('spree_custom_products_id_seq'::regclass) not null
        primary key,
    sku         varchar,
    price       numeric(20, 5),
    barcodes    text[]  default '{}'::text[],
    created_at  timestamp                                                         not null,
    updated_at  timestamp                                                         not null,
    name_ar     varchar,
    name_en     varchar,
    height      numeric(8, 2),
    width       numeric(8, 2),
    depth       numeric(8, 2),
    weight      numeric(8, 2),
    to_be_cased boolean default false
);

create table spree_custom_line_items
(
    id                 integer default nextval('spree_custom_line_items_id_seq'::regclass) not null
        primary key,
    order_id           integer,
    price              numeric(20, 5),
    quantity           integer,
    requested_quantity integer,
    created_at         timestamp                                                           not null,
    updated_at         timestamp                                                           not null,
    custom_product_id  integer
        constraint fk_rails_139950958d
            references spree_custom_products,
    replaced           boolean default false,
    replacement        boolean default false
);

create index index_spree_custom_line_items_on_custom_product_id
    on spree_custom_line_items (custom_product_id);

create index index_spree_custom_line_items_on_order_id
    on spree_custom_line_items (order_id);

create index index_spree_custom_products_on_sku
    on spree_custom_products (sku);

create index index_spree_custom_products_on_barcodes
    on spree_custom_products using gin (barcodes);

create table spree_content_draws
(
    id                            integer default nextval('spree_content_draws_id_seq'::regclass) not null
        primary key,
    title                         varchar,
    enabled                       boolean default false,
    start_time                    timestamp,
    end_time                      timestamp,
    free_entry_eligible           boolean default false,
    online_order_eligible         boolean default false,
    in_store_order_eligible       boolean default false,
    created_at                    timestamp                                                       not null,
    updated_at                    timestamp                                                       not null,
    display_image_en_file_name    varchar,
    display_image_en_content_type varchar,
    display_image_en_file_size    integer,
    display_image_en_updated_at   timestamp,
    display_image_ar_file_name    varchar,
    display_image_ar_content_type varchar,
    display_image_ar_file_size    integer,
    display_image_ar_updated_at   timestamp
);

create table spree_content_draw_translations
(
    id                    integer default nextval('spree_content_draw_translations_id_seq'::regclass) not null
        primary key,
    spree_content_draw_id integer                                                                     not null,
    locale                varchar                                                                     not null,
    created_at            timestamp                                                                   not null,
    updated_at            timestamp                                                                   not null,
    title                 varchar,
    description           text,
    how_it_works          text,
    terms_and_conditions  text
);

create index index_spree_content_draw_translations_on_spree_content_draw_id
    on spree_content_draw_translations (spree_content_draw_id);

create index index_spree_content_draw_translations_on_locale
    on spree_content_draw_translations (locale);

create table spree_content_draw_submissions
(
    id                     integer default nextval('spree_content_draw_submissions_id_seq'::regclass) not null
        primary key,
    draw_id                integer,
    user_id                integer,
    category               varchar,
    state                  varchar,
    decline_reason         varchar,
    online_order_id        integer,
    in_store_order_number  varchar,
    in_store_order_total   numeric(20, 5),
    in_store_code          varchar,
    created_at             timestamp                                                                  not null,
    updated_at             timestamp                                                                  not null,
    in_store_purchase_date date
);

create index index_spree_content_draw_submissions_on_draw_id
    on spree_content_draw_submissions (draw_id);

create index index_spree_content_draw_submissions_on_user_id
    on spree_content_draw_submissions (user_id);

create index index_spree_content_draw_submissions_on_online_order_id
    on spree_content_draw_submissions (online_order_id);

create table spree_content_draw_coupons
(
    id            integer default nextval('spree_content_draw_coupons_id_seq'::regclass) not null
        primary key,
    number        varchar,
    submission_id integer,
    category      varchar,
    qualifier     jsonb   default '"{}"'::jsonb,
    created_at    timestamp                                                              not null,
    updated_at    timestamp                                                              not null
);

create index index_spree_content_draw_coupons_on_submission_id
    on spree_content_draw_coupons (submission_id);

create table spree_content_draw_products
(
    id         integer default nextval('spree_content_draw_products_id_seq'::regclass) not null
        primary key,
    draw_id    integer,
    product_id integer,
    created_at timestamp                                                               not null,
    updated_at timestamp                                                               not null
);

create index index_spree_content_draw_products_on_draw_id
    on spree_content_draw_products (draw_id);

create index index_spree_content_draw_products_on_product_id
    on spree_content_draw_products (product_id);

create table spree_product_barcodes
(
    id         integer default nextval('spree_product_barcodes_id_seq'::regclass) not null
        primary key,
    product_id integer,
    barcode    varchar,
    created_at timestamp                                                          not null,
    updated_at timestamp                                                          not null
);

create index index_spree_product_barcodes_on_product_id
    on spree_product_barcodes (product_id);

create unique index index_spree_product_barcodes_on_barcode
    on spree_product_barcodes (barcode);

create table spree_user_notifications
(
    id            integer default nextval('spree_user_notifications_id_seq'::regclass) not null
        primary key,
    user_id       integer,
    title_en      varchar,
    title_ar      varchar,
    content_en    varchar,
    content_ar    varchar,
    action_type   varchar,
    action_target varchar,
    icon_type     varchar,
    created_at    timestamp                                                            not null,
    updated_at    timestamp                                                            not null,
    global        boolean default false,
    expires_at    timestamp
);

create index index_spree_user_notifications_on_user_id
    on spree_user_notifications (user_id);

create table spree_user_clients
(
    id                      integer default nextval('spree_user_clients_id_seq'::regclass) not null
        primary key,
    user_id                 integer,
    platform                varchar,
    uuid                    varchar,
    push_notification_token varchar,
    location                geography(Point, 4326),
    enabled                 boolean default true,
    created_at              timestamp                                                      not null,
    updated_at              timestamp                                                      not null
);

create index index_spree_user_clients_on_user_id
    on spree_user_clients (user_id);

create index index_spree_user_clients_on_uuid
    on spree_user_clients (uuid);

create table spree_lift_ticket_missing_barcodes
(
    id                integer default nextval('spree_lift_ticket_missing_barcodes_id_seq'::regclass) not null
        primary key,
    scanned_barcode   varchar,
    resolved          boolean default false,
    order_id          integer,
    ticketable_type   varchar,
    ticketable_id     integer,
    created_at        timestamp                                                                      not null,
    updated_at        timestamp                                                                      not null,
    customer_reported boolean default false,
    reported_count    integer default 0
);

create index index_spree_lift_ticket_missing_barcodes_on_order_id
    on spree_lift_ticket_missing_barcodes (order_id);

create index index_spree_lift_ticketable
    on spree_lift_ticket_missing_barcodes (ticketable_type, ticketable_id);

create table spree_internal_attachments
(
    id                 integer default nextval('spree_internal_attachments_id_seq'::regclass) not null
        primary key,
    image_file_name    varchar,
    image_content_type varchar,
    image_file_size    integer,
    image_updated_at   timestamp,
    ticketable_id      integer,
    created_at         timestamp                                                              not null,
    updated_at         timestamp                                                              not null,
    ticketable_type    varchar
);

create index index_spree_internal_attachments_on_ticketable_id
    on spree_internal_attachments (ticketable_id);

create table spree_content_app_banners
(
    id                    integer default nextval('spree_content_app_banners_id_seq'::regclass) not null
        primary key,
    title                 varchar,
    enabled               boolean default true,
    position              integer default 1,
    deeplink_ios          varchar,
    deeplink_android      varchar,
    start_time            timestamp,
    end_time              timestamp,
    image_en_file_name    varchar,
    image_en_content_type varchar,
    image_en_file_size    integer,
    image_en_updated_at   timestamp,
    image_ar_file_name    varchar,
    image_ar_content_type varchar,
    image_ar_file_size    integer,
    image_ar_updated_at   timestamp,
    title_ar              varchar,
    web_url_en            varchar,
    web_url_ar            varchar,
    express               boolean default false
);

create table spree_content_web_banners
(
    id                            integer default nextval('spree_content_web_banners_id_seq'::regclass) not null
        primary key,
    title                         varchar,
    enabled                       boolean default true,
    position                      integer default 1,
    target_url                    varchar,
    start_time                    timestamp,
    end_time                      timestamp,
    image_desktop_en_file_name    varchar,
    image_desktop_en_content_type varchar,
    image_desktop_en_file_size    integer,
    image_desktop_en_updated_at   timestamp,
    image_desktop_ar_file_name    varchar,
    image_desktop_ar_content_type varchar,
    image_desktop_ar_file_size    integer,
    image_desktop_ar_updated_at   timestamp,
    image_mobile_en_file_name     varchar,
    image_mobile_en_content_type  varchar,
    image_mobile_en_file_size     integer,
    image_mobile_en_updated_at    timestamp,
    image_mobile_ar_file_name     varchar,
    image_mobile_ar_content_type  varchar,
    image_mobile_ar_file_size     integer,
    image_mobile_ar_updated_at    timestamp
);

create table spree_content_brochures
(
    id                         integer default nextval('spree_content_brochures_id_seq'::regclass) not null
        primary key,
    title                      varchar,
    display_image_file_name    varchar,
    display_image_content_type varchar,
    display_image_file_size    integer,
    display_image_updated_at   timestamp,
    document_file_name         varchar,
    document_content_type      varchar,
    document_file_size         integer,
    document_updated_at        timestamp,
    position                   integer default 0,
    visible                    boolean default false,
    created_at                 timestamp                                                           not null,
    updated_at                 timestamp                                                           not null,
    supermarket_id             integer
);

create table spree_content_brochure_translations
(
    id                        integer default nextval('spree_content_brochure_translations_id_seq'::regclass) not null
        primary key,
    spree_content_brochure_id integer                                                                         not null,
    locale                    varchar                                                                         not null,
    created_at                timestamp                                                                       not null,
    updated_at                timestamp                                                                       not null,
    title                     varchar
);

create index index_c8b8719f942d1ae84a5463357118aa0a950c75e7
    on spree_content_brochure_translations (spree_content_brochure_id);

create index index_spree_content_brochure_translations_on_locale
    on spree_content_brochure_translations (locale);

create table spree_drift_deliveries
(
    id                          integer          default nextval('spree_drift_deliveries_id_seq'::regclass) not null
        primary key,
    sort_order                  integer          default 0,
    location                    jsonb            default '[]'::jsonb,
    status                      varchar          default 'pending'::character varying,
    delivery_batch_id           integer,
    order_id                    integer,
    created_at                  timestamp                                                                   not null,
    updated_at                  timestamp                                                                   not null,
    latitude_on_arrival         double precision default 0.0,
    longitude_on_arrival        double precision default 0.0,
    distance_on_arrival         double precision default 0.0,
    not_in_radius_attempt_count integer          default 0,
    carrier_reference_id        varchar
);

create index index_spree_drift_deliveries_on_delivery_batch_id
    on spree_drift_deliveries (delivery_batch_id);

create index index_spree_drift_deliveries_on_order_id
    on spree_drift_deliveries (order_id);

create table spree_drift_tickets
(
    id              integer default nextval('spree_drift_tickets_id_seq'::regclass) not null
        primary key,
    details         varchar,
    resolved        boolean default false,
    ticketable_type varchar,
    ticketable_id   integer,
    created_at      timestamp                                                       not null,
    updated_at      timestamp                                                       not null
);

create index index_spree_drift_tickets_on_ticketable_type_and_ticketable_id
    on spree_drift_tickets (ticketable_type, ticketable_id);

create table spree_user_phone_number_otps
(
    id           integer default nextval('spree_user_phone_number_otps_id_seq'::regclass) not null
        primary key,
    code         integer                                                                  not null,
    user_id      integer                                                                  not null,
    is_used      boolean default false,
    phone_number varchar                                                                  not null,
    verified_at  timestamp,
    attempts     integer default 0,
    created_at   timestamp                                                                not null,
    updated_at   timestamp                                                                not null,
    expires_at   timestamp
);

create table spree_order_sms_templates
(
    id          integer default nextval('spree_order_sms_templates_id_seq'::regclass) not null
        primary key,
    title       varchar,
    template_en varchar,
    template_ar varchar,
    key         varchar,
    created_at  timestamp                                                             not null,
    updated_at  timestamp                                                             not null
);

create table spree_lift_aisle_maps
(
    id             integer default nextval('spree_lift_aisle_maps_id_seq'::regclass) not null
        primary key,
    supermarket_id integer,
    taxon_id       integer,
    sort_order     integer,
    name           varchar,
    created_at     timestamp                                                         not null,
    updated_at     timestamp                                                         not null,
    perishable     boolean default false
);

create index index_spree_lift_aisle_maps_on_supermarket_id
    on spree_lift_aisle_maps (supermarket_id);

create index index_spree_lift_aisle_maps_on_taxon_id
    on spree_lift_aisle_maps (taxon_id);

create table spree_lift_assignments
(
    id            integer default nextval('spree_lift_assignments_id_seq'::regclass) not null
        primary key,
    delivery_date date,
    delivery_slot varchar,
    items         integer default 0,
    status        varchar default 'pending'::character varying,
    order_id      integer,
    picker_id     integer,
    created_at    timestamp                                                          not null,
    updated_at    timestamp                                                          not null
);

create index index_spree_lift_assignments_on_picker_id
    on spree_lift_assignments (picker_id);

create unique index index_spree_lift_assignments_on_order_id
    on spree_lift_assignments (order_id);

create table spree_shelf_supervisors
(
    id                   integer default nextval('spree_shelf_supervisors_id_seq'::regclass) not null
        primary key,
    username             varchar,
    encrypted_password   varchar,
    locked_at            timestamp,
    deleted_at           timestamp,
    supermarket_id       integer,
    name                 varchar,
    authentication_token varchar,
    admin                boolean default false,
    locale               varchar default 'en'::character varying,
    created_at           timestamp                                                           not null,
    updated_at           timestamp                                                           not null
);

create index index_spree_shelf_supervisors_on_username
    on spree_shelf_supervisors (username);

create index index_spree_shelf_supervisors_on_deleted_at
    on spree_shelf_supervisors (deleted_at);

create index index_spree_shelf_supervisors_on_supermarket_id
    on spree_shelf_supervisors (supermarket_id);

create index index_spree_shelf_supervisors_on_authentication_token
    on spree_shelf_supervisors (authentication_token);

create table spree_shelf_reviews
(
    id                        integer default nextval('spree_shelf_reviews_id_seq'::regclass) not null
        primary key,
    barcode                   varchar,
    status                    varchar default 'pending'::character varying,
    snoozed_until             timestamp,
    supermarket_id            integer,
    order_id                  integer,
    product_id                integer,
    picker_id                 integer,
    created_at                timestamp                                                       not null,
    updated_at                timestamp                                                       not null,
    aisle_name                varchar default ''::character varying,
    aisle_name_at_pickingtime varchar default ''::character varying,
    out_of_stock_at           timestamp,
    in_stock_at               timestamp
);

create index index_spree_shelf_reviews_on_status
    on spree_shelf_reviews (status);

create index index_spree_shelf_reviews_on_supermarket_id
    on spree_shelf_reviews (supermarket_id);

create index index_spree_shelf_reviews_on_order_id
    on spree_shelf_reviews (order_id);

create index index_spree_shelf_reviews_on_product_id
    on spree_shelf_reviews (product_id);

create index index_spree_shelf_reviews_on_picker_id
    on spree_shelf_reviews (picker_id);

create unique index index_spree_shelf_reviews_on_supermarket_id_and_product_id
    on spree_shelf_reviews (supermarket_id, product_id);

create table spree_shelf_email_alerts
(
    id             integer default nextval('spree_shelf_email_alerts_id_seq'::regclass) not null
        primary key,
    supermarket_id integer,
    recipients_to  jsonb   default '[]'::jsonb,
    recipients_cc  jsonb   default '[]'::jsonb,
    enabled        boolean default true,
    created_at     timestamp                                                            not null,
    updated_at     timestamp                                                            not null
);

create index index_spree_shelf_email_alerts_on_supermarket_id
    on spree_shelf_email_alerts (supermarket_id);

create table spree_box_packers
(
    id                   integer default nextval('spree_box_packers_id_seq'::regclass) not null
        primary key,
    username             varchar,
    encrypted_password   varchar,
    locked_at            timestamp,
    deleted_at           timestamp,
    supermarket_id       integer,
    name                 varchar,
    authentication_token varchar,
    admin                boolean default false,
    locale               varchar default 'en'::character varying,
    created_at           timestamp                                                     not null,
    updated_at           timestamp                                                     not null
);

create index index_spree_box_packers_on_username
    on spree_box_packers (username);

create index index_spree_box_packers_on_deleted_at
    on spree_box_packers (deleted_at);

create index index_spree_box_packers_on_supermarket_id
    on spree_box_packers (supermarket_id);

create index index_spree_box_packers_on_authentication_token
    on spree_box_packers (authentication_token);

create table spree_quality_checker_results
(
    id               integer default nextval('spree_quality_checker_results_id_seq'::regclass) not null
        primary key,
    scanned_barcode  varchar,
    valid_product    boolean,
    resolved         boolean,
    verified_at      timestamp,
    comment          text,
    solution_type    varchar,
    resultable_type  varchar,
    resultable_id    integer,
    created_at       timestamp                                                                 not null,
    updated_at       timestamp                                                                 not null,
    reported_by_type varchar,
    reported_by_id   integer
);

create index index_spree_checker_resultable
    on spree_quality_checker_results (resultable_type, resultable_id);

create index index_spree_reported_by
    on spree_quality_checker_results (reported_by_type, reported_by_id);

create table danube_picker_waves
(
    id                    integer default nextval('danube_picker_waves_id_seq'::regclass) not null
        primary key,
    name                  varchar,
    expected_picker_count integer,
    picking_start_time    time,
    picking_end_time      time,
    supermarket_id        integer,
    created_at            timestamp                                                       not null,
    updated_at            timestamp                                                       not null
);

create index index_danube_picker_waves_on_supermarket_id
    on danube_picker_waves (supermarket_id);

create table danube_picker_waves_time_slots
(
    picker_wave_id integer,
    time_slot_id   integer
);

create index index_danube_picker_waves_time_slots_on_picker_wave_id
    on danube_picker_waves_time_slots (picker_wave_id);

create index index_danube_picker_waves_time_slots_on_time_slot_id
    on danube_picker_waves_time_slots (time_slot_id);

create table danube_delivery_waves
(
    id             integer default nextval('danube_delivery_waves_id_seq'::regclass) not null
        primary key,
    name           varchar,
    supermarket_id integer,
    created_at     timestamp                                                         not null,
    updated_at     timestamp                                                         not null
);

create index index_danube_delivery_waves_on_supermarket_id
    on danube_delivery_waves (supermarket_id);

create table danube_delivery_waves_time_slots
(
    delivery_wave_id integer,
    time_slot_id     integer
);

create index index_danube_delivery_waves_time_slots_on_delivery_wave_id
    on danube_delivery_waves_time_slots (delivery_wave_id);

create index index_danube_delivery_waves_time_slots_on_time_slot_id
    on danube_delivery_waves_time_slots (time_slot_id);

create table read_user_notifications
(
    user_id         integer,
    notification_id integer
);

create index index_read_user_notifications_on_user_id
    on read_user_notifications (user_id);

create index index_read_user_notifications_on_notification_id
    on read_user_notifications (notification_id);

create unique index index_read_user_notifications_on_user_id_and_notification_id
    on read_user_notifications (user_id, notification_id);

create table danube_app_ratings
(
    id               integer default nextval('danube_app_ratings_id_seq'::regclass) not null
        primary key,
    value            integer,
    user_id          integer,
    build_version    varchar,
    codepush_version varchar,
    platform         varchar,
    rated_at         timestamp,
    created_at       timestamp                                                      not null,
    updated_at       timestamp                                                      not null
);

create table freshdesk_tickets
(
    id                    integer default nextval('freshdesk_tickets_id_seq'::regclass) not null
        primary key,
    user_id               integer,
    deleted               boolean,
    description           varchar,
    description_text      varchar,
    due_by                timestamp,
    fr_escalated          boolean,
    group_id              double precision,
    is_escalated          boolean,
    priority              integer,
    ticket_type           varchar,
    status                varchar,
    spam                  boolean,
    source                integer,
    requester_id          double precision,
    responder_id          double precision,
    updated_at            timestamp,
    created_at            timestamp,
    ticket_id             double precision,
    fd_created_at         timestamp,
    fd_updated_at         timestamp,
    subject               varchar,
    cf_complaint_category varchar,
    cf_branch             varchar,
    cf_offline_complaint  varchar,
    cf_order_number       varchar,
    cf_department         varchar,
    cf_description        varchar,
    cf_product_name       varchar
);

create table spree_referrals
(
    id                 integer default nextval('spree_referrals_id_seq'::regclass) not null
        primary key,
    referrer_id        integer
        constraint fk_rails_501bab7ffd
            references spree_users,
    referee_id         integer
        constraint fk_rails_d072b237dc
            references spree_users,
    device_id          varchar,
    issued_to_referrer boolean default false                                       not null,
    issued_to_referee  boolean default false                                       not null,
    created_at         timestamp                                                   not null,
    updated_at         timestamp                                                   not null
);

create index index_spree_referrals_on_referrer_id
    on spree_referrals (referrer_id);

create index index_spree_referrals_on_referee_id
    on spree_referrals (referee_id);

create unique index index_spree_referrals_on_referrer_id_and_referee_id
    on spree_referrals (referrer_id, referee_id);

create table spree_bin_categories
(
    id         integer default nextval('spree_bin_categories_id_seq'::regclass) not null
        primary key,
    tag        varchar                                                          not null,
    sort_order integer,
    created_at timestamp                                                        not null,
    updated_at timestamp                                                        not null,
    name_en    varchar,
    name_ar    varchar
);

create table spree_products
(
    id                               integer        default nextval('spree_products_id_seq'::regclass) not null primary key,
    name                             varchar        default ''::character varying                      not null,
    description                      text,
    available_on                     timestamp,
    deleted_at                       timestamp,
    slug                             varchar,
    meta_description                 text,
    meta_keywords                    varchar,
    tax_category_id                  integer,
    shipping_category_id             integer,
    created_at                       timestamp,
    updated_at                       timestamp,
    promotionable                    boolean        default true,
    meta_title                       varchar,
    avg_rating                       numeric(7, 5)  default 0.0                                        not null,
    reviews_count                    integer        default 0                                          not null,
    in_stock                         boolean        default true,
    magerecord_product_entity_id     integer,
    magerecord_product_id            integer,
    bundled                          boolean        default false,
    moq_limit                        integer        default 0                                          not null,
    bin_category_id                  integer constraint fk_rails_c6eeed6ed5 references spree_bin_categories,
    crushable                        boolean        default false,
    refundable                       boolean        default true,
    cod_enabled                      boolean        default true                                       not null,
    loyalty_point                    numeric(20, 4) default 0.0,
    availability_type                integer        default 1,
    depend_only_inventory_details    boolean        default false,
    electronic_product_code          varchar,
    purchases_last_7_days            integer        default 0,
    purchases_last_7_days_updated_at timestamp,
    subscription_only                boolean        default false,
    loyalty_synced_at                timestamp      default CURRENT_TIMESTAMP,
    loyalty_sync_key                 varchar
);

create table spree_product_promotion_rules
(
    product_id        integer
        constraint fk_rails_cd36696389
            references spree_products,
    promotion_rule_id integer
        constraint fk_rails_f4bc451ee6
            references spree_promotion_rules,
    id                integer default nextval('spree_product_promotion_rules_id_seq'::regclass) not null
        primary key,
    created_at        timestamp,
    updated_at        timestamp
);

create index index_products_promotion_rules_on_product_id
    on spree_product_promotion_rules (product_id);

create index index_products_promotion_rules_on_promotion_rule_id
    on spree_product_promotion_rules (promotion_rule_id);

create index index_spree_products_on_available_on
    on spree_products (available_on);

create index index_spree_products_on_deleted_at
    on spree_products (deleted_at);

create index index_spree_products_on_name
    on spree_products (name);

create unique index index_spree_products_on_slug
    on spree_products (slug);

create index index_spree_products_on_bin_category_id
    on spree_products (bin_category_id);

create index index_spree_products_on_loyalty_synced_at
    on spree_products (loyalty_synced_at);

create index index_spree_products_on_loyalty_point
    on spree_products (loyalty_point);

create table spree_product_inventory_modifiers
(
    id                                   integer default nextval('spree_product_inventory_modifiers_id_seq'::regclass) not null
        primary key,
    product_id                           integer                                                                       not null
        constraint fk_rails_976f3a218b
            references spree_products
            on delete cascade,
    enabled                              boolean default false,
    action_price                         numeric(20, 5),
    action_available                     boolean,
    action_in_stock                      boolean,
    rule_delivery_method                 varchar,
    rule_supermarket_id                  integer,
    created_at                           timestamp                                                                     not null,
    updated_at                           timestamp                                                                     not null,
    representation_key                   varchar,
    custom_product_id                    integer,
    action_sale_price                    numeric(20, 5),
    action_sale_start                    timestamp,
    action_sale_end                      timestamp,
    availability_start_time              timestamp,
    availability_end_time                timestamp,
    stock_quantity                       integer,
    uploaded_stock_quantity              integer,
    offline_price                        numeric(20, 5),
    price_increment_percentage           double precision,
    subscription_price_start_date        timestamp,
    subscription_price_end_date          timestamp,
    subscription_price                   numeric(20, 5),
    subscription_availability_start_date timestamp,
    subscription_availability_end_date   timestamp
);

create index index_spree_product_inventory_modifiers_on_rule_supermarket_id
    on spree_product_inventory_modifiers (rule_supermarket_id);

create index index_spree_product_inventory_modifiers_on_product_id
    on spree_product_inventory_modifiers (product_id);

create table spree_product_aisle_maps
(
    id             integer default nextval('spree_product_aisle_maps_id_seq'::regclass) not null
        primary key,
    product_id     integer
        constraint fk_rails_2665e174ec
            references spree_products,
    supermarket_id integer
        constraint fk_rails_5a33400584
            references danube_supermarkets,
    name           varchar,
    created_at     timestamp                                                            not null,
    updated_at     timestamp                                                            not null
);

create index index_spree_product_aisle_maps_on_product_id
    on spree_product_aisle_maps (product_id);

create index index_spree_product_aisle_maps_on_supermarket_id
    on spree_product_aisle_maps (supermarket_id);

create unique index index_spree_product_aisle_maps_on_product_id_and_supermarket_id
    on spree_product_aisle_maps (product_id, supermarket_id);

create table spree_bundle_products
(
    id                integer default nextval('spree_bundle_products_id_seq'::regclass) not null
        primary key,
    master_product_id integer                                                           not null
        constraint fk_rails_77cb7ba75c
            references spree_products,
    child_product_id  integer                                                           not null
        constraint fk_rails_eafa4daf79
            references spree_products,
    quantity          integer default 1                                                 not null,
    created_at        timestamp                                                         not null,
    updated_at        timestamp                                                         not null
);

create index index_spree_bundle_products_on_master_product_id
    on spree_bundle_products (master_product_id);

create index index_spree_bundle_products_on_child_product_id
    on spree_bundle_products (child_product_id);

create unique index index_bundle_products_master_child
    on spree_bundle_products (master_product_id, child_product_id);

create table spree_product_recommendations
(
    id                 integer default nextval('spree_product_recommendations_id_seq'::regclass) not null
        primary key,
    product_id         integer
        constraint fk_rails_47a202049b
            references spree_products,
    related_product_id integer
        constraint fk_rails_8c3e85d856
            references spree_products,
    created_at         timestamp                                                                 not null,
    updated_at         timestamp                                                                 not null
);

create index index_spree_product_recommendations_on_product_id
    on spree_product_recommendations (product_id);

create index index_spree_product_recommendations_on_related_product_id
    on spree_product_recommendations (related_product_id);

create unique index index_product_recommendations_on_product_and_related_product
    on spree_product_recommendations (product_id, related_product_id);

create unique index index_spree_bin_categories_on_tag
    on spree_bin_categories (tag);

create table spree_order_containers
(
    id              integer default nextval('spree_order_containers_id_seq'::regclass) not null
        primary key,
    width           double precision,
    height          double precision,
    depth           double precision,
    shipping_cost   double precision,
    max_weight      double precision,
    bin_category_id integer
        constraint fk_rails_5ae9e6fe6b
            references spree_bin_categories
);

create index index_spree_order_containers_on_bin_category_id
    on spree_order_containers (bin_category_id);

create table spree_order_bins
(
    id              integer default nextval('spree_order_bins_id_seq'::regclass) not null
        primary key,
    bin_category_id integer
        constraint fk_rails_2ce5b70c35
            references spree_bin_categories,
    order_id        integer
        constraint fk_rails_68fcb5c86e
            references spree_orders,
    container_id    integer
        constraint fk_rails_6d3dafba52
            references spree_order_containers,
    used_space      double precision,
    stack_height    double precision,
    unit_number     integer
);

create index index_spree_order_bins_on_bin_category_id
    on spree_order_bins (bin_category_id);

create index index_spree_order_bins_on_order_id
    on spree_order_bins (order_id);

create index index_spree_order_bins_on_container_id
    on spree_order_bins (container_id);

create table spree_line_item_bins
(
    id           integer default nextval('spree_line_item_bins_id_seq'::regclass) not null
        primary key,
    line_item_id integer
        constraint fk_rails_4c39505ddc
            references spree_line_items,
    order_bin_id integer
        constraint fk_rails_2dccb8abaf
            references spree_order_bins,
    quantity     integer,
    created_at   timestamp                                                        not null,
    updated_at   timestamp                                                        not null
);

create index index_spree_line_item_bins_on_line_item_id
    on spree_line_item_bins (line_item_id);

create index index_spree_line_item_bins_on_order_bin_id
    on spree_line_item_bins (order_bin_id);

create unique index index_spree_line_item_bins_on_line_item_id_and_order_bin_id
    on spree_line_item_bins (line_item_id, order_bin_id);

create table spree_weighted_dimensions
(
    id         integer          default nextval('spree_weighted_dimensions_id_seq'::regclass) not null
        primary key,
    variant_id integer
        constraint fk_rails_dc661244d8
            references spree_variants,
    width      double precision default 0.0,
    height     double precision default 0.0,
    depth      double precision default 0.0,
    weight     double precision                                                               not null,
    created_at timestamp                                                                      not null,
    updated_at timestamp                                                                      not null
);

create index index_spree_weighted_dimensions_on_variant_id
    on spree_weighted_dimensions (variant_id);

create unique index index_spree_weighted_dimensions_on_variant_id_and_weight
    on spree_weighted_dimensions (variant_id, weight);

create table spree_store_credit_campaigns
(
    id            integer default nextval('spree_store_credit_campaigns_id_seq'::regclass) not null
        primary key,
    name          varchar,
    expires_at    timestamp,
    uses_per_user integer,
    no_of_codes   integer,
    amount        double precision                                                         not null,
    currency      varchar,
    created_at    timestamp                                                                not null,
    updated_at    timestamp                                                                not null
);

create table spree_store_credit_coupons
(
    id                       integer default nextval('spree_store_credit_coupons_id_seq'::regclass) not null
        primary key,
    code                     varchar                                                                not null,
    redeemed_at              timestamp,
    user_id                  integer,
    store_credit_id          integer,
    created_at               timestamp                                                              not null,
    updated_at               timestamp                                                              not null,
    comment                  varchar,
    store_credit_campaign_id integer
        constraint fk_rails_b818fd20f3
            references spree_store_credit_campaigns
);

create index index_spree_store_credit_coupons_on_store_credit_id
    on spree_store_credit_coupons (store_credit_id);

create index index_spree_store_credit_coupons_on_store_credit_campaign_id
    on spree_store_credit_coupons (store_credit_campaign_id);

create table spree_product_price_versions
(
    id             integer default nextval('spree_product_price_versions_id_seq'::regclass) not null
        primary key,
    item_type      varchar                                                                  not null,
    item_id        integer                                                                  not null,
    event          varchar                                                                  not null,
    whodunnit      varchar,
    created_at     timestamp                                                                not null,
    comments       varchar,
    date_of_action timestamp,
    whodunnit_type varchar default 'Spree::User'::character varying,
    object         jsonb,
    object_changes jsonb,
    updated_at     timestamp                                                                not null
);

create index index_spree_product_price_versions_on_item_type
    on spree_product_price_versions (item_type);

create index index_spree_product_price_versions_on_item_id
    on spree_product_price_versions (item_id);

create index index_spree_product_price_versions_on_object_and_object_changes
    on spree_product_price_versions (object, object_changes);

create table spree_kitchen_recipe_translations
(
    id                      integer default nextval('spree_kitchen_recipe_translations_id_seq'::regclass) not null
        primary key,
    spree_kitchen_recipe_id integer                                                                       not null,
    locale                  varchar                                                                       not null,
    created_at              timestamp                                                                     not null,
    updated_at              timestamp                                                                     not null,
    name                    varchar,
    recipe                  text,
    description             varchar,
    cooking_time            varchar
);

create index index_01f6543073f6fc82b18795d1ac20400adee3679f
    on spree_kitchen_recipe_translations (spree_kitchen_recipe_id);

create index index_spree_kitchen_recipe_translations_on_locale
    on spree_kitchen_recipe_translations (locale);

create table spree_kitchen_cuisines
(
    id         integer default nextval('spree_kitchen_cuisines_id_seq'::regclass) not null
        primary key,
    name_en    varchar,
    name_ar    varchar,
    sort_order integer,
    tag        varchar,
    created_at timestamp                                                          not null,
    updated_at timestamp                                                          not null
);

create table spree_kitchen_recipes
(
    id                         integer default nextval('spree_kitchen_recipes_id_seq'::regclass) not null
        primary key,
    calories                   integer,
    visible                    boolean default false,
    display_image_file_name    varchar,
    display_image_content_type varchar,
    display_image_file_size    integer,
    display_image_updated_at   timestamp,
    created_at                 timestamp                                                         not null,
    updated_at                 timestamp                                                         not null,
    cuisine_id                 integer
        constraint fk_rails_d7ac701f6e
            references spree_kitchen_cuisines,
    servings                   varchar,
    home_icon_file_name        varchar,
    home_icon_content_type     varchar,
    home_icon_file_size        integer,
    home_icon_updated_at       timestamp,
    banner_file_name           varchar,
    banner_content_type        varchar,
    banner_file_size           integer,
    banner_updated_at          timestamp,
    position                   integer default 0                                                 not null
);

create index index_spree_kitchen_recipes_on_cuisine_id
    on spree_kitchen_recipes (cuisine_id);

create table spree_kitchen_ingredients
(
    id                     integer default nextval('spree_kitchen_ingredients_id_seq'::regclass) not null
        primary key,
    name_en                varchar,
    name_ar                varchar,
    recommended_product_id integer
        constraint fk_rails_f703fb6d04
            references spree_products,
    taxon_id               integer
        constraint fk_rails_170ea60f72
            references spree_taxons,
    kitchen_recipe_id      integer
        constraint fk_rails_eb3a54023b
            references spree_kitchen_recipes,
    quantity               varchar,
    measurement            integer,
    created_at             timestamp                                                             not null,
    updated_at             timestamp                                                             not null,
    cut_pattern_id         integer
);

create index index_spree_kitchen_ingredients_on_recommended_product_id
    on spree_kitchen_ingredients (recommended_product_id);

create index index_spree_kitchen_ingredients_on_taxon_id
    on spree_kitchen_ingredients (taxon_id);

create index index_spree_kitchen_ingredients_on_kitchen_recipe_id
    on spree_kitchen_ingredients (kitchen_recipe_id);

create table spree_testimonials
(
    id          integer default nextval('spree_testimonials_id_seq'::regclass) not null
        primary key,
    title       varchar,
    description text,
    name        varchar,
    city        varchar,
    phone       varchar,
    created_at  timestamp                                                      not null,
    updated_at  timestamp                                                      not null,
    lang_type   varchar
);

create table spree_user_e_cards
(
    id                      integer        default nextval('spree_user_e_cards_id_seq'::regclass) not null
        primary key,
    user_id                 integer
        constraint fk_rails_bddb759081
            references spree_users,
    line_item_id            integer
        constraint fk_rails_b80c42ae1d
            references spree_line_items,
    batch_id                varchar,
    key                     varchar,
    number                  varchar,
    amount                  numeric(20, 5) default 0.0,
    custom_id               varchar,
    expiry_date             timestamp,
    style_image             varchar,
    image_url               varchar,
    created_at              timestamp                                                             not null,
    updated_at              timestamp                                                             not null,
    trx_ref_number          varchar,
    one_card_secret         varchar,
    one_card_trx_ref_number varchar
);

create index index_spree_user_e_cards_on_user_id
    on spree_user_e_cards (user_id);

create index index_spree_user_e_cards_on_line_item_id
    on spree_user_e_cards (line_item_id);

create unique index index_spree_user_e_cards_on_line_item_id_and_number
    on spree_user_e_cards (line_item_id, number);

create table spree_preferred_cuts
(
    id                integer default nextval('spree_preferred_cuts_id_seq'::regclass) not null
        primary key,
    name              varchar,
    created_at        timestamp                                                        not null,
    updated_at        timestamp                                                        not null,
    important_text_en text,
    important_text_ar text,
    cut_type          varchar
);

create table spree_cut_patterns
(
    id                         integer default nextval('spree_cut_patterns_id_seq'::regclass) not null
        primary key,
    name_en                    varchar,
    name_ar                    varchar,
    "default"                  boolean default false,
    visible                    boolean default false,
    display_image_file_name    varchar,
    display_image_content_type varchar,
    display_image_file_size    integer,
    display_image_updated_at   timestamp,
    preferred_cut_id           integer,
    created_at                 timestamp                                                      not null,
    updated_at                 timestamp                                                      not null
);

create index index_spree_cut_patterns_on_preferred_cut_id
    on spree_cut_patterns (preferred_cut_id);

create table spree_products_preferred_cuts
(
    id               integer default nextval('spree_products_preferred_cuts_id_seq'::regclass) not null
        primary key,
    product_id       integer,
    preferred_cut_id integer,
    created_at       timestamp                                                                 not null,
    updated_at       timestamp                                                                 not null
);

create table spree_line_item_cut_patterns
(
    id             integer default nextval('spree_line_item_cut_patterns_id_seq'::regclass) not null
        primary key,
    line_item_id   integer                                                                  not null,
    cut_pattern_id integer                                                                  not null,
    quantity       integer                                                                  not null,
    created_at     timestamp                                                                not null,
    updated_at     timestamp                                                                not null
);

create table spree_stage_stagers
(
    id                   integer default nextval('spree_stage_stagers_id_seq1'::regclass) not null
        primary key,
    username             varchar,
    encrypted_password   varchar,
    locked_at            timestamp,
    deleted_at           timestamp,
    supermarket_id       integer,
    name                 varchar,
    authentication_token varchar,
    admin                boolean default false,
    locale               varchar default 'en'::character varying,
    created_at           timestamp                                                        not null,
    updated_at           timestamp                                                        not null
);

create index index_spree_stage_stagers_on_username
    on spree_stage_stagers (username);

create index index_spree_stage_stagers_on_deleted_at
    on spree_stage_stagers (deleted_at);

create index index_spree_stage_stagers_on_supermarket_id
    on spree_stage_stagers (supermarket_id);

create index index_spree_stage_stagers_on_authentication_token
    on spree_stage_stagers (authentication_token);

create table spree_nutritional_facts
(
    id          integer default nextval('spree_nutritional_facts_id_seq'::regclass) not null
        primary key,
    quantity_en varchar,
    nutrients   jsonb   default '"{}"'::jsonb,
    comments_en text,
    product_id  integer
        constraint fk_rails_2dd7506426
            references spree_products,
    created_at  timestamp                                                           not null,
    updated_at  timestamp                                                           not null,
    quantity_ar varchar,
    comments_ar text
);

create index index_spree_nutritional_facts_on_product_id
    on spree_nutritional_facts (product_id);

create table spree_nutritions
(
    id         integer default nextval('spree_nutritions_id_seq'::regclass) not null
        primary key,
    quantity   varchar,
    nutrients  jsonb   default '"{}"'::jsonb,
    comments   text,
    product_id integer
        constraint fk_rails_902a9a9ec9
            references spree_products,
    created_at timestamp                                                    not null,
    updated_at timestamp                                                    not null
);

create index index_spree_nutritions_on_product_id
    on spree_nutritions (product_id);

create table spree_nutrition_details
(
    id         integer default nextval('spree_nutrition_details_id_seq'::regclass) not null
        primary key,
    quantity   varchar,
    nutrients  jsonb   default '"{}"'::jsonb,
    comments   text,
    product_id integer
        constraint fk_rails_6825ef8203
            references spree_products,
    created_at timestamp                                                           not null,
    updated_at timestamp                                                           not null
);

create index index_spree_nutrition_details_on_product_id
    on spree_nutrition_details (product_id);

create table spree_electronic_items_details
(
    id                    integer default nextval('spree_electronic_items_details_id_seq'::regclass) not null
        primary key,
    serial_number         varchar                                                                    not null,
    document_file_name    varchar,
    document_content_type varchar,
    document_file_size    integer,
    document_updated_at   timestamp,
    line_item_id          integer                                                                    not null
        constraint fk_rails_04820d08d3
            references spree_line_items,
    created_at            timestamp                                                                  not null,
    updated_at            timestamp                                                                  not null,
    spree_product_id      bigint                                                                     not null
        constraint fk_rails_0f124b09ae
            references spree_products
);

create index index_spree_electronic_items_details_on_line_item_id
    on spree_electronic_items_details (line_item_id);

create index index_spree_electronic_items_details_on_spree_product_id
    on spree_electronic_items_details (spree_product_id);

create table spree_loading_areas
(
    id                 integer default nextval('spree_loading_areas_id_seq'::regclass) not null
        primary key,
    area               varchar                                                         not null,
    created_at         timestamp                                                       not null,
    updated_at         timestamp                                                       not null,
    load_number        integer,
    van_number         integer,
    supermarket_id     integer
        constraint fk_rails_0d5f38cec2
            references danube_supermarkets,
    time_slot_id       integer
        constraint fk_rails_6e5c345ee5
            references danube_time_slots,
    shipping_method_id integer
        constraint fk_rails_8c7c92eb1e
            references spree_shipping_methods
);

create index index_spree_loading_areas_on_supermarket_id
    on spree_loading_areas (supermarket_id);

create index index_spree_loading_areas_on_time_slot_id
    on spree_loading_areas (time_slot_id);

create unique index index_spree_loading_areas_on_load_number_and_supermarket_id
    on spree_loading_areas (load_number, supermarket_id);

create index index_spree_loading_areas_on_shipping_method_id
    on spree_loading_areas (shipping_method_id);

create table spree_promotion_audit_logs
(
    id             integer default nextval('spree_promotion_audit_logs_id_seq'::regclass) not null
        primary key,
    item_type      varchar                                                                not null,
    item_id        integer                                                                not null,
    event          varchar                                                                not null,
    whodunnit      varchar,
    created_at     timestamp                                                              not null,
    comments       varchar,
    date_of_action timestamp,
    whodunnit_type varchar default 'Spree::User'::character varying,
    object         jsonb,
    object_changes jsonb,
    updated_at     timestamp                                                              not null
);

create index index_spree_promotion_audit_logs_on_item_type
    on spree_promotion_audit_logs (item_type);

create index index_spree_promotion_audit_logs_on_item_id
    on spree_promotion_audit_logs (item_id);

create index index_spree_promotion_audit_logs_on_object_and_object_changes
    on spree_promotion_audit_logs (object, object_changes);

create table danube_head_quarter_email_alerts
(
    id            integer default nextval('danube_head_quarter_email_alerts_id_seq'::regclass) not null
        primary key,
    action        varchar,
    description   text,
    recipients_to jsonb   default '[]'::jsonb,
    recipients_cc jsonb   default '[]'::jsonb,
    enabled       boolean default true,
    created_at    timestamp                                                                    not null,
    updated_at    timestamp                                                                    not null
);

create table spree_loading_areas_districts
(
    id              integer default nextval('spree_loading_areas_districts_id_seq'::regclass) not null
        primary key,
    loading_area_id integer                                                                   not null,
    district_id     integer                                                                   not null,
    created_at      timestamp                                                                 not null,
    updated_at      timestamp                                                                 not null
);

create index index_spree_loading_areas_districts_on_loading_area_id
    on spree_loading_areas_districts (loading_area_id);

create index index_spree_loading_areas_districts_on_district_id
    on spree_loading_areas_districts (district_id);

create table spree_loading_areas_drivers
(
    id              integer default nextval('spree_loading_areas_drivers_id_seq'::regclass) not null
        primary key,
    loading_area_id integer                                                                 not null,
    driver_id       integer                                                                 not null,
    created_at      timestamp                                                               not null,
    updated_at      timestamp                                                               not null
);

create index index_spree_loading_areas_drivers_on_loading_area_id
    on spree_loading_areas_drivers (loading_area_id);

create index index_spree_loading_areas_drivers_on_driver_id
    on spree_loading_areas_drivers (driver_id);

create table danube_referral_programs
(
    id                           integer          default nextval('danube_referral_programs_id_seq'::regclass) not null
        primary key,
    referee_credit_amount        double precision default 0.0,
    referrer_credit_amount       double precision default 0.0,
    referee_credit_expiry_days   integer          default 0,
    referrer_credit_expiry_days  integer          default 0,
    max_referee_count            integer          default 0,
    max_referral_earnings_limit  double precision default 0.0,
    recipients_to                jsonb            default '[]'::jsonb,
    banner_image_en_file_name    varchar,
    banner_image_en_content_type varchar,
    banner_image_en_file_size    integer,
    banner_image_en_updated_at   timestamp,
    banner_title_en              text,
    banner_content_en            jsonb            default '[]'::jsonb,
    banner_image_ar_file_name    varchar,
    banner_image_ar_content_type varchar,
    banner_image_ar_file_size    integer,
    banner_image_ar_updated_at   timestamp,
    banner_title_ar              text,
    banner_content_ar            jsonb            default '[]'::jsonb,
    enabled                      boolean          default false,
    store_id                     integer,
    created_at                   timestamp                                                                     not null,
    updated_at                   timestamp                                                                     not null,
    currency                     varchar          default 'SAR'::character varying
);

create index index_danube_referral_programs_on_store_id
    on danube_referral_programs (store_id);

create table spree_content_taxon_banners
(
    id                    integer default nextval('spree_content_taxon_banners_id_seq'::regclass) not null
        primary key,
    enabled               boolean default true,
    deeplink_ios          varchar,
    deeplink_android      varchar,
    start_time            timestamp,
    end_time              timestamp,
    web_url_en            varchar,
    web_url_ar            varchar,
    image_en_file_name    varchar,
    image_en_content_type varchar,
    image_en_file_size    integer,
    image_en_updated_at   timestamp,
    image_ar_file_name    varchar,
    image_ar_content_type varchar,
    image_ar_file_size    integer,
    image_ar_updated_at   timestamp,
    taxon_id              integer
        constraint fk_rails_f1fd08e2e5
            references spree_taxons
            on delete set null,
    title_en              varchar
);

create index index_spree_content_taxon_banners_on_taxon_id
    on spree_content_taxon_banners (taxon_id);

create table spree_security_inspectors
(
    id                   integer default nextval('spree_security_inspectors_id_seq'::regclass) not null
        primary key,
    username             varchar,
    encrypted_password   varchar,
    locked_at            timestamp,
    deleted_at           timestamp,
    supermarket_id       integer
        constraint fk_rails_3a3eaa36da
            references danube_supermarkets,
    name                 varchar,
    authentication_token varchar,
    admin                boolean default false,
    locale               varchar default 'en'::character varying,
    created_at           timestamp                                                             not null,
    updated_at           timestamp                                                             not null
);

create index index_spree_security_inspectors_on_username
    on spree_security_inspectors (username);

create index index_spree_security_inspectors_on_deleted_at
    on spree_security_inspectors (deleted_at);

create index index_spree_security_inspectors_on_supermarket_id
    on spree_security_inspectors (supermarket_id);

create index index_spree_security_inspectors_on_authentication_token
    on spree_security_inspectors (authentication_token);

create table spree_order_return_items
(
    id                      integer default nextval('spree_order_return_items_id_seq'::regclass) not null
        primary key,
    line_item_id            integer
        constraint fk_rails_ba6e43b1a5
            references spree_line_items,
    reason                  varchar,
    quantity                integer,
    created_at              timestamp                                                            not null,
    updated_at              timestamp                                                            not null,
    custom_line_item_id     integer
        constraint fk_rails_5aa9fabc5d
            references spree_custom_line_items
            on delete cascade,
    returned_after_delivery boolean default false
);

create index index_spree_order_return_items_on_line_item_id
    on spree_order_return_items (line_item_id);

create index index_spree_order_return_items_on_custom_line_item_id
    on spree_order_return_items (custom_line_item_id);

create table spree_content_strip_banners
(
    id                    integer default nextval('spree_content_strip_banners_id_seq'::regclass) not null
        primary key,
    title_en              varchar,
    title_ar              varchar,
    enabled               boolean default true,
    position              integer,
    deeplink_ios          varchar,
    deeplink_android      varchar,
    start_time            timestamp,
    end_time              timestamp,
    web_url_en            varchar,
    web_url_ar            varchar,
    image_en_file_name    varchar,
    image_en_content_type varchar,
    image_en_file_size    integer,
    image_en_updated_at   timestamp,
    image_ar_file_name    varchar,
    image_ar_content_type varchar,
    image_ar_file_size    integer,
    image_ar_updated_at   timestamp,
    created_at            timestamp                                                               not null,
    updated_at            timestamp                                                               not null
);

create table spree_search_recommendations
(
    id               integer default nextval('spree_search_recommendations_id_seq'::regclass) not null
        primary key,
    name_en          varchar,
    name_ar          varchar,
    enabled          boolean default true,
    position         integer,
    deeplink_ios     varchar,
    deeplink_android varchar,
    created_at       timestamp                                                                not null,
    updated_at       timestamp                                                                not null
);

create table spree_loyalty_rewards
(
    id                           integer        default nextval('spree_loyalty_rewards_id_seq'::regclass) not null
        primary key,
    user_id                      integer
        constraint fk_rails_d215fb57c5
            references spree_users,
    source_type                  varchar,
    source_id                    integer,
    location_code                varchar,
    transaction_type_code        varchar,
    transaction_unique_reference varchar,
    value                        numeric(20, 6),
    base_points                  numeric(20, 4),
    bonus_points                 numeric(20, 4),
    points_earned                numeric(20, 6),
    transaction_product_list     jsonb          default '[]'::jsonb,
    created_at                   timestamp                                                                not null,
    updated_at                   timestamp                                                                not null,
    points_redeemed              numeric(20, 4) default NULL::numeric
);

create index index_spree_loyalty_rewards_on_user_id
    on spree_loyalty_rewards (user_id);

create index index_spree_loyalty_rewards_on_source_type_and_source_id
    on spree_loyalty_rewards (source_type, source_id);

create index index_spree_loyalty_rewards_on_transaction_unique_reference
    on spree_loyalty_rewards (transaction_unique_reference);

create index index_spree_loyalty_rewards_on_transaction_type_code
    on spree_loyalty_rewards (transaction_type_code);

create table danube_express_supermarkets
(
    id                     integer default nextval('danube_express_supermarkets_id_seq'::regclass) not null
        primary key,
    supermarket_id         integer
        constraint fk_rails_c0feb09ad5
            references danube_supermarkets,
    time_slot_buffer       integer,
    slot_capacity_per_hour integer,
    coverage               geography(Polygon, 4326),
    location               geography(Point, 4326),
    created_at             timestamp                                                               not null,
    updated_at             timestamp                                                               not null,
    logo_file_name         varchar,
    logo_content_type      varchar,
    logo_file_size         integer,
    logo_updated_at        timestamp,
    center                 geography(Point, 4326)
);

create index index_danube_express_supermarkets_on_supermarket_id
    on danube_express_supermarkets (supermarket_id);

create index index_danube_express_supermarkets_on_coverage
    on danube_express_supermarkets (coverage);

create index index_danube_express_supermarkets_on_location
    on danube_express_supermarkets (location);

create table spree_express_busy_slots
(
    id             integer default nextval('spree_express_busy_slots_id_seq'::regclass) not null
        primary key,
    day_of_week    integer,
    start_time     time,
    end_time       time,
    enabled        boolean,
    supermarket_id integer
        constraint fk_rails_b31edbcf98
            references danube_supermarkets,
    modified_by_id integer
        constraint fk_rails_eb3610b1bc
            references spree_users,
    created_at     timestamp                                                            not null,
    updated_at     timestamp                                                            not null,
    closed         boolean default false                                                not null
);

create index index_spree_express_busy_slots_on_supermarket_id
    on spree_express_busy_slots (supermarket_id);

create index index_spree_express_busy_slots_on_modified_by_id
    on spree_express_busy_slots (modified_by_id);

create table spree_fulfilment_fulfillers
(
    id                   integer default nextval('spree_fulfilment_fulfillers_id_seq'::regclass) not null
        primary key,
    username             varchar,
    encrypted_password   varchar,
    locked_at            timestamp,
    deleted_at           timestamp,
    supermarket_id       integer,
    name                 varchar,
    authentication_token varchar,
    admin                boolean default false,
    locale               varchar default 'en'::character varying,
    created_at           timestamp                                                               not null,
    updated_at           timestamp                                                               not null,
    role_type            varchar
);

create table spree_drift_drivers
(
    id                   integer default nextval('spree_drift_drivers_id_seq'::regclass) not null
        primary key,
    username             varchar,
    encrypted_password   varchar,
    locked_at            timestamp,
    deleted_at           timestamp,
    supermarket_id       integer,
    name                 varchar,
    authentication_token varchar,
    admin                boolean default false,
    locale               varchar default 'en'::character varying,
    created_at           timestamp                                                       not null,
    updated_at           timestamp                                                       not null,
    fulfiller_id         integer
        constraint fk_rails_1ef8ba72e6
            references spree_fulfilment_fulfillers
            on delete set null
);

create index index_spree_drift_drivers_on_username
    on spree_drift_drivers (username);

create index index_spree_drift_drivers_on_deleted_at
    on spree_drift_drivers (deleted_at);

create index index_spree_drift_drivers_on_supermarket_id
    on spree_drift_drivers (supermarket_id);

create index index_spree_drift_drivers_on_authentication_token
    on spree_drift_drivers (authentication_token);

create index index_spree_drift_drivers_on_fulfiller_id
    on spree_drift_drivers (fulfiller_id);

create table spree_lift_pickers
(
    id                   integer default nextval('spree_lift_pickers_id_seq'::regclass) not null
        primary key,
    username             varchar,
    encrypted_password   varchar,
    locked_at            timestamp,
    deleted_at           timestamp,
    supermarket_id       integer,
    name                 varchar,
    authentication_token varchar,
    admin                boolean default false,
    locale               varchar default 'en'::character varying,
    created_at           timestamp                                                      not null,
    updated_at           timestamp                                                      not null,
    fulfiller_id         integer
        constraint fk_rails_95f3f4c9b8
            references spree_fulfilment_fulfillers
            on delete set null
);

create index index_spree_lift_pickers_on_username
    on spree_lift_pickers (username);

create index index_spree_lift_pickers_on_deleted_at
    on spree_lift_pickers (deleted_at);

create index index_spree_lift_pickers_on_supermarket_id
    on spree_lift_pickers (supermarket_id);

create index index_spree_lift_pickers_on_authentication_token
    on spree_lift_pickers (authentication_token);

create index index_spree_lift_pickers_on_fulfiller_id
    on spree_lift_pickers (fulfiller_id);

create table spree_picked_items
(
    id            integer default nextval('spree_picked_items_id_seq'::regclass) not null
        primary key,
    assignment_id integer,
    order_id      integer,
    quantity      integer,
    picked_at     timestamp,
    pickable_type varchar,
    pickable_id   integer,
    created_at    timestamp                                                      not null,
    updated_at    timestamp                                                      not null,
    picker_id     integer
        constraint fk_rails_7c69c14da9
            references spree_lift_pickers
);

create index index_spree_picked_items_on_assignment_id
    on spree_picked_items (assignment_id);

create index index_spree_picked_items_on_order_id
    on spree_picked_items (order_id);

create index index_spree_item_pickable
    on spree_picked_items (pickable_type, pickable_id);

create index index_spree_picked_items_on_picker_id
    on spree_picked_items (picker_id);

create index index_spree_fulfilment_fulfillers_on_username
    on spree_fulfilment_fulfillers (username);

create index index_spree_fulfilment_fulfillers_on_deleted_at
    on spree_fulfilment_fulfillers (deleted_at);

create index index_spree_fulfilment_fulfillers_on_supermarket_id
    on spree_fulfilment_fulfillers (supermarket_id);

create index index_spree_fulfilment_fulfillers_on_authentication_token
    on spree_fulfilment_fulfillers (authentication_token);

create table danube_express_contracts
(
    id                    integer default nextval('danube_express_contracts_id_seq'::regclass) not null
        primary key,
    supermarket_id        integer,
    document_file_name    varchar,
    document_content_type varchar,
    document_file_size    integer,
    document_updated_at   timestamp,
    created_at            timestamp                                                            not null,
    updated_at            timestamp                                                            not null
);

create index index_danube_express_contracts_on_supermarket_id
    on danube_express_contracts (supermarket_id);

create table spree_drift_carriers
(
    id             serial
        primary key,
    name           varchar,
    provider_class varchar,
    auth_key       varchar,
    created_at     timestamp not null,
    updated_at     timestamp not null,
    base_url       varchar,
    api_key        varchar,
    deleted_at     timestamp
);

create table spree_drift_delivery_batches
(
    id             integer default nextval('spree_drift_delivery_batches_id_seq'::regclass) not null
        primary key,
    date           date,
    start_time     time,
    end_time       time,
    optimized      boolean default false,
    status         varchar default 'pending'::character varying,
    driver_id      integer,
    supermarket_id integer,
    created_at     timestamp                                                                not null,
    updated_at     timestamp                                                                not null,
    name           varchar,
    carrier_id     integer
        constraint fk_rails_7460a9093b
            references spree_drift_carriers
);

create index index_spree_drift_delivery_batches_on_driver_id
    on spree_drift_delivery_batches (driver_id);

create index index_spree_drift_delivery_batches_on_supermarket_id
    on spree_drift_delivery_batches (supermarket_id);

create index index_spree_drift_delivery_batches_on_carrier_id
    on spree_drift_delivery_batches (carrier_id);

create table spree_user_gift_cards
(
    id              serial
        primary key,
    purchased_by_id integer
        constraint fk_rails_20fc35dd1b
            references spree_users,
    used_by_id      integer
        constraint fk_rails_3f77ff8902
            references spree_users,
    line_item_id    integer
        constraint fk_rails_7aa3da76cf
            references spree_line_items,
    number          varchar,
    transaction_id  varchar,
    barcode         varchar,
    amount          numeric(20, 5),
    activated       boolean default false,
    created_at      timestamp not null,
    updated_at      timestamp not null
);

create index index_spree_user_gift_cards_on_purchased_by_id
    on spree_user_gift_cards (purchased_by_id);

create index index_spree_user_gift_cards_on_used_by_id
    on spree_user_gift_cards (used_by_id);

create index index_spree_user_gift_cards_on_line_item_id
    on spree_user_gift_cards (line_item_id);

create unique index index_spree_user_gift_cards_on_number
    on spree_user_gift_cards (number);

create table spree_districts_time_slots_schedules
(
    id                     serial
        primary key,
    district_id            integer
        constraint fk_rails_84170ec1e5
            references spree_districts,
    time_slots_schedule_id integer
        constraint fk_rails_8d1c9436af
            references danube_time_slots_schedules,
    created_at             timestamp not null,
    updated_at             timestamp not null
);

create index index_on_district_tss_district_id
    on spree_districts_time_slots_schedules (district_id);

create index index_on_district_tss_time_slots_schedule_id
    on spree_districts_time_slots_schedules (time_slots_schedule_id);

create unique index index_districts_time_slots
    on spree_districts_time_slots_schedules (district_id, time_slots_schedule_id);

create table spree_last_minute_buys
(
    id           serial
        primary key,
    name         varchar,
    description  varchar,
    starts_at    timestamp,
    expires_at   timestamp,
    match_policy varchar default 'all'::character varying
);

create table spree_last_minute_buy_rules
(
    id                 serial
        primary key,
    last_minute_buy_id integer,
    type               varchar,
    sku_numbers        varchar,
    taxon_ids          varchar,
    match_taxon_ids    varchar,
    match_sku_number   varchar
);

create table spree_last_minute_buy_products
(
    id                      serial
        primary key,
    last_minute_buy_rule_id integer,
    variant_id              integer,
    position                integer
);

create table spree_loading_area_versions
(
    id             serial
        primary key,
    item_type      varchar   not null,
    item_id        integer   not null,
    event          varchar   not null,
    whodunnit      varchar,
    created_at     timestamp not null,
    comments       varchar,
    date_of_action timestamp,
    whodunnit_type varchar default 'Spree::User'::character varying,
    object         jsonb,
    object_changes jsonb,
    updated_at     timestamp not null
);

create index index_spree_loading_area_versions_on_item_type
    on spree_loading_area_versions (item_type);

create index index_spree_loading_area_versions_on_item_id
    on spree_loading_area_versions (item_id);

create table spree_order_quotations
(
    id          serial
        primary key,
    token       varchar,
    sent_at     timestamp,
    approved_at timestamp,
    order_id    integer
);

create index index_spree_order_quotations_on_token
    on spree_order_quotations (token);

create index index_spree_order_quotations_on_order_id
    on spree_order_quotations (order_id);

create table parttime_fulfillers
(
    id             serial
        primary key,
    first_name     varchar,
    last_name      varchar,
    nationality    varchar,
    "DOB"          date,
    gender         integer,
    email          varchar,
    phone          varchar,
    supermarket_id integer,
    vehicle_no     varchar,
    created_at     timestamp not null,
    updated_at     timestamp not null
);

create table spree_attachments
(
    id                      serial
        primary key,
    attachable_id           integer,
    attachable_type         varchar,
    attachment              varchar,
    attachment_type         varchar,
    attachment_file_name    varchar,
    attachment_content_type varchar,
    created_at              timestamp not null,
    updated_at              timestamp not null
);

create index index_spree_attachments_on_attachable_id
    on spree_attachments (attachable_id);

create table spree_free_product_promotions
(
    id           bigserial
        primary key,
    name         varchar,
    description  varchar,
    starts_at    timestamp,
    expires_at   timestamp,
    usage_limit  integer,
    match_policy varchar default 'all'::character varying,
    created_at   timestamp(6) not null,
    updated_at   timestamp(6) not null,
    deleted_at   timestamp
);

create index index_spree_free_product_promotions_on_starts_at
    on spree_free_product_promotions (starts_at);

create index index_spree_free_product_promotions_on_usage_limit
    on spree_free_product_promotions (usage_limit);

create table spree_orders_free_samples
(
    id                   bigserial
        primary key,
    order_id             integer,
    adjustment_id        integer,
    free_sample_id       integer,
    free_sample_quantity integer,
    supermarket_id       integer,
    created_at           timestamp(6) not null,
    updated_at           timestamp(6) not null
);

create index index_spree_orders_free_samples_on_order_id
    on spree_orders_free_samples (order_id);

create index index_spree_orders_free_samples_on_adjustment_id
    on spree_orders_free_samples (adjustment_id);

create table spree_sample_product_details
(
    id                       bigserial
        primary key,
    sample_master_product_id bigint
        constraint fk_rails_39b3ce2931
            references spree_products,
    sample_child_product_id  bigint
        constraint fk_rails_9d762ea353
            references spree_products,
    created_at               timestamp(6) not null,
    updated_at               timestamp(6) not null
);

create index index_spree_sample_product_details_on_sample_master_product_id
    on spree_sample_product_details (sample_master_product_id);

create index index_spree_sample_product_details_on_sample_child_product_id
    on spree_sample_product_details (sample_child_product_id);

create unique index index_sample_products_master_child
    on spree_sample_product_details (sample_master_product_id, sample_child_product_id);

create table spree_lift_report_evidences
(
    id         bigserial
        primary key,
    picker_id  bigint
        constraint fk_rails_c8d90a867f
            references spree_lift_pickers,
    review_id  bigint
        constraint fk_rails_d55a1d3e53
            references spree_shelf_reviews,
    order_id   bigint
        constraint fk_rails_6b1098a9e3
            references spree_orders,
    created_at timestamp(6) not null,
    updated_at timestamp(6) not null
);

create index index_spree_lift_report_evidences_on_picker_id
    on spree_lift_report_evidences (picker_id);

create index index_spree_lift_report_evidences_on_review_id
    on spree_lift_report_evidences (review_id);

create index index_spree_lift_report_evidences_on_order_id
    on spree_lift_report_evidences (order_id);

create table spree_credit_owed_payments
(
    id              bigserial
        primary key,
    source_order_id integer
        constraint fk_rails_9fb2363419
            references spree_orders,
    target_order_id integer
        constraint fk_rails_2c84122e55
            references spree_orders,
    amount          numeric(20, 5) default 0.0 not null,
    user_id         integer
        constraint fk_rails_7e2f2bd731
            references spree_users,
    state           varchar,
    comments        varchar,
    created_at      timestamp(6)               not null,
    updated_at      timestamp(6)               not null
);

create index index_spree_credit_owed_payments_on_user_id
    on spree_credit_owed_payments (user_id);

create index index_spree_credit_owed_payments_on_target_order_id
    on spree_credit_owed_payments (target_order_id);

create unique index index_spree_credit_owed_payments_on_source_and_target_order
    on spree_credit_owed_payments (source_order_id, target_order_id);

create table spree_credit_owed_payment_logs
(
    id             bigserial
        primary key,
    item_type      varchar not null,
    item_id        integer not null,
    event          varchar not null,
    whodunnit      varchar,
    created_at     timestamp,
    comments       varchar,
    date_of_action timestamp,
    whodunnit_type varchar default 'Spree::User'::character varying,
    object         jsonb,
    object_changes jsonb
);

create index index_spree_credit_owed_payment_logs_on_item_type
    on spree_credit_owed_payment_logs (item_type);

create index index_spree_credit_owed_payment_logs_on_item_id
    on spree_credit_owed_payment_logs (item_id);

create table spree_subscription_plans
(
    id                     bigserial
        primary key,
    name                   varchar,
    valid_for_days         integer default 0 not null,
    price                  numeric(20, 5)    not null,
    delivery_fee           numeric(20, 5),
    minimum_order_total    numeric(20, 5),
    applicable_order_count integer default 0 not null,
    plan_enabled           boolean default false,
    editable               boolean default true,
    deleted_at             timestamp,
    product_id             integer           not null
        constraint fk_rails_0c40ced0ed
            references spree_products,
    created_at             timestamp(6)      not null,
    updated_at             timestamp(6)      not null
);

create index index_spree_subscription_plans_on_product_id
    on spree_subscription_plans (product_id);

create table spree_subscription_plan_translations
(
    id                         bigserial
        primary key,
    spree_subscription_plan_id bigint       not null,
    locale                     varchar      not null,
    created_at                 timestamp(6) not null,
    updated_at                 timestamp(6) not null,
    name                       varchar,
    description                text,
    discount_title             text
);

create index index_568cf6f5635e91887004059ddc8c0c26671e9d89
    on spree_subscription_plan_translations (spree_subscription_plan_id);

create index index_spree_subscription_plan_translations_on_locale
    on spree_subscription_plan_translations (locale);

create table spree_subscription_plan_accounts
(
    id                   bigserial
        primary key,
    subscription_plan_id integer
        constraint fk_rails_b39bc7cce9
            references spree_subscription_plans,
    user_id              integer
        constraint fk_rails_6e6848edc3
            references spree_users,
    status               varchar,
    deleted_at           timestamp,
    canceled_at          timestamp,
    created_at           timestamp(6) not null,
    updated_at           timestamp(6) not null,
    renewal_order_id     integer
        constraint fk_rails_9ef9adba9e
            references spree_orders
);

create index index_spree_subscription_plan_accounts_on_subscription_plan_id
    on spree_subscription_plan_accounts (subscription_plan_id);

create index index_spree_subscription_plan_accounts_on_user_id
    on spree_subscription_plan_accounts (user_id);

create table spree_subscription_plan_account_periods
(
    id            bigserial
        primary key,
    account_id    integer               not null
        constraint fk_rails_5ebc920c2d
            references spree_subscription_plan_accounts,
    order_id      integer               not null
        constraint fk_rails_b67e2c82ba
            references spree_orders,
    activated_at  timestamp,
    expires_at    timestamp,
    plan_settings jsonb   default '{}'::jsonb,
    created_at    timestamp(6)          not null,
    updated_at    timestamp(6)          not null,
    renewed       boolean default false not null,
    order_count   integer default 0     not null
);

create index index_spree_subscription_plan_account_periods_on_account_id
    on spree_subscription_plan_account_periods (account_id);

create index index_spree_subscription_plan_account_periods_on_order_id
    on spree_subscription_plan_account_periods (order_id);

create table spree_subscription_plan_supermarkets
(
    id             bigserial
        primary key,
    plan_id        bigint       not null
        constraint fk_rails_c1c662a173
            references spree_subscription_plans
            on delete cascade,
    supermarket_id bigint       not null
        constraint fk_rails_fd11b61282
            references danube_supermarkets
            on delete cascade,
    created_at     timestamp(6) not null,
    updated_at     timestamp(6) not null
);

create index index_spree_subscription_plan_supermarkets_on_plan_id
    on spree_subscription_plan_supermarkets (plan_id);

create index index_spree_subscription_plan_supermarkets_on_supermarket_id
    on spree_subscription_plan_supermarkets (supermarket_id);

create table spree_subscription_plan_contents
(
    id                   bigserial
        primary key,
    title                varchar,
    description          varchar,
    icon_file_name       varchar,
    icon_content_type    varchar,
    icon_file_size       bigint,
    icon_updated_at      timestamp,
    subscription_plan_id integer      not null
        constraint fk_rails_a3a60e454d
            references spree_subscription_plans
            on delete cascade,
    created_at           timestamp(6) not null,
    updated_at           timestamp(6) not null
);

create index index_spree_subscription_plan_contents_on_subscription_plan_id
    on spree_subscription_plan_contents (subscription_plan_id);

create table spree_subscription_plan_content_translations
(
    id                                 bigserial
        primary key,
    spree_subscription_plan_content_id bigint       not null,
    locale                             varchar      not null,
    created_at                         timestamp(6) not null,
    updated_at                         timestamp(6) not null,
    title                              varchar,
    description                        varchar
);

create index index_32785beaf32a7d477418cdf9d864331aee8c6e8c
    on spree_subscription_plan_content_translations (spree_subscription_plan_content_id);

create index index_spree_subscription_plan_content_translations_on_locale
    on spree_subscription_plan_content_translations (locale);

create table spree_subscription_plan_accounts_user_addresses
(
    id              bigserial
        primary key,
    account_id      integer               not null
        constraint fk_rails_94fdb01dc2
            references spree_subscription_plan_accounts,
    user_address_id integer               not null
        constraint fk_rails_7df82eda82
            references spree_user_addresses,
    is_primary      boolean default false not null,
    created_at      timestamp(6)          not null,
    updated_at      timestamp(6)          not null
);

create index plan_account_address_account_id_index
    on spree_subscription_plan_accounts_user_addresses (account_id);

create index plan_account_address_address_id_index
    on spree_subscription_plan_accounts_user_addresses (user_address_id);

create table spree_content_email_images
(
    id                    bigserial
        primary key,
    title                 varchar               not null,
    email_type            varchar               not null,
    image_type            varchar               not null,
    image_en_file_name    varchar               not null,
    image_en_content_type varchar               not null,
    image_en_file_size    bigint                not null,
    image_en_updated_at   timestamp             not null,
    image_ar_file_name    varchar               not null,
    image_ar_content_type varchar               not null,
    image_ar_file_size    bigint                not null,
    image_ar_updated_at   timestamp             not null,
    visible               boolean default false not null,
    created_at            timestamp(6)          not null,
    updated_at            timestamp(6)          not null
);

create table spree_add_events
(
    id                   bigserial
        primary key,
    add_event_id         integer      not null,
    deleted_at           timestamp,
    created_at           timestamp(6) not null,
    updated_at           timestamp(6) not null,
    add_event_url        varchar,
    add_event_unique_key varchar
);

create table spree_cashbacks
(
    id                  bigserial
        primary key,
    order_id            integer,
    promotion_action_id integer,
    promotion_code_id   integer,
    label               varchar,
    amount              numeric(20, 5) default 0.0 not null,
    eligible            boolean        default false,
    expires_at          timestamp,
    store_credit_id     integer,
    created_at          timestamp(6)               not null,
    updated_at          timestamp(6)               not null
);

create index index_cashbacks_on_order_id
    on spree_cashbacks (order_id);

create index index_cashbacks_on_promotion_action_id
    on spree_cashbacks (promotion_action_id);

create index index_spree_cashbacks_on_promotion_code_id
    on spree_cashbacks (promotion_code_id);

create table danube_supermarket_products
(
    id             bigserial
        primary key,
    supermarket_id bigint
        constraint fk_rails_899bf9e29b
            references danube_supermarkets
            on delete cascade,
    product_id     bigint
        constraint fk_rails_c4ebe71ba3
            references spree_products
            on delete cascade
);

create index index_danube_supermarket_products_on_supermarket_id
    on danube_supermarket_products (supermarket_id);

create unique index index_danube_supermarket_products_on_product_id
    on danube_supermarket_products (product_id);

create table spree_invoices
(
    id               bigserial
        primary key,
    order_id         integer               not null
        constraint fk_rails_047300ffd7
            references spree_orders,
    type             varchar               not null,
    public_id        varchar               not null,
    is_qr_generated  boolean default false not null,
    is_pdf_generated boolean default false not null,
    meta             jsonb   default '"{}"'::jsonb,
    created_at       timestamp(6)          not null,
    updated_at       timestamp(6)          not null,
    qr_file_name     varchar,
    qr_content_type  varchar,
    qr_file_size     bigint,
    qr_updated_at    timestamp,
    pdf_file_name    varchar,
    pdf_content_type varchar,
    pdf_file_size    bigint,
    pdf_updated_at   timestamp,
    qr_data          varchar,
    job_id           varchar
);

create index index_spree_invoices_on_order_id
    on spree_invoices (order_id);

create unique index index_spree_invoices_on_public_id
    on spree_invoices (public_id);

create table spree_country_translations
(
    id               bigserial
        primary key,
    spree_country_id integer      not null,
    locale           varchar      not null,
    created_at       timestamp(6) not null,
    updated_at       timestamp(6) not null,
    name             varchar
);

create index index_spree_country_translations_on_spree_country_id
    on spree_country_translations (spree_country_id);

create index index_spree_country_translations_on_locale
    on spree_country_translations (locale);

