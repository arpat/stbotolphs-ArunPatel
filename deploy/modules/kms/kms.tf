resource "google_kms_key_ring" "main_keyring" {
  project  = "stbotolphs-297814"
  name     = "main-keyring"
  location = "europe-west1"
}

resource "google_kms_crypto_key" "sql_crypto_key" {
  name     = "sql-crypto-key"
  key_ring = google_kms_key_ring.main_keyring.self_link
}
