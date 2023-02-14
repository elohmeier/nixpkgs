{ lib
, boost
, fetchFromGitHub
, libsodium
, nix
, pkg-config
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
  version = "dev";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "harmonia";
    rev = "f91c62c7568de3f32634ba88c38db74420b3b4e3";
    hash = "sha256-2idIxPPPDc8/0gqrSAM8Wdc6xYoVw6rMIamoxBkB2qk=";
  };

  cargoHash = "sha256-t1jf5FhjdJ95bzdm8U8CzUeP17bTSmnkN8UGxJNKubY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    boost
    libsodium
    nix
  ];

  meta = with lib; {
    description = "Nix binary cache";
    homepage = "https://github.com/helsinki-systems/harmonia";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
