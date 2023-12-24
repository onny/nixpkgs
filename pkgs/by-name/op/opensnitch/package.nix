{ buildGoModule
, fetchFromGitHub
, fetchpatch
, protobuf
, go-protobuf
, pkg-config
, libnetfilter_queue
, libnfnetlink
, lib
, coreutils
, iptables
, makeWrapper
, protoc-gen-go-grpc
, testers
, opensnitch
, nixosTests
}:

buildGoModule rec {
  pname = "opensnitch";
  version = "unstable-2023-12-22";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "ffb76683aa804e7052013dbab7132a31239a09dc";
    hash = "sha256-6mytjJPF9lI/hq0Hspt6DLOOQ8zvou2fCerzhNxfGN4=";
  };

  postPatch = ''
    # Allow configuring Version at build time
    substituteInPlace daemon/core/version.go --replace "const " "var "
  '';

  modRoot = "daemon";

  buildInputs = [
    libnetfilter_queue
    libnfnetlink
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    go-protobuf
    makeWrapper
    protoc-gen-go-grpc
  ];

  vendorHash = "sha256-PX41xeUJb/WKv3+z5kbRmJNP1vFu8x35NZvN2Dgp4CQ=";

  preBuild = ''
    # Fix inconsistent vendoring build error
    # https://github.com/evilsocket/opensnitch/issues/770
    cp ${./go.mod} go.mod
    cp ${./go.sum} go.sum

    make -C ../proto ../daemon/ui/protocol/ui.pb.go
  '';

  postBuild = ''
    mv $GOPATH/bin/daemon $GOPATH/bin/opensnitchd
    mkdir -p $out/etc/opensnitchd $out/lib/systemd/system
    cp system-fw.json $out/etc/opensnitchd/
    substitute default-config.json $out/etc/opensnitchd/default-config.json \
      --replace "/var/log/opensnitchd.log" "/dev/stdout"
    substitute opensnitchd.service $out/lib/systemd/system/opensnitchd.service \
      --replace "/usr/local/bin/opensnitchd" "$out/bin/opensnitchd" \
      --replace "/etc/opensnitchd/rules" "/var/lib/opensnitch/rules" \
      --replace "/bin/mkdir" "${coreutils}/bin/mkdir"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/evilsocket/opensnitch/daemon/core.Version=${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/opensnitchd \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
  '';

  # FIXME
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) opensnitch;
    version = testers.testVersion {
      package = opensnitch;
      command = "opensnitchd -version";
    };
  };

  meta = with lib; {
    description = "An application firewall";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
