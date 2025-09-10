{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tmux-githop";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "callumio";
    repo = "tmux-githop";
    rev = "v${version}";
    hash = "sha256-ydxaEIPTJrQtAMaF14vFhC1qlmVGiD/4WQ85qOB+jDE=";
  };

  vendorHash = "sha256-xTZBpNc7P8jLCPpsv3cTclVNtLwbW3O/LcF4mYAzXsM=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "Fast tmux session hopping between git repos";
    homepage = "https://github.com/callumio/tmux-githop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [callumio];
    mainProgram = "tmux-githop";
  };
}
