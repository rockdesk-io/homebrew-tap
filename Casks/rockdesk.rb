cask "rockdesk" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.12"
  sha256 arm:   "82225d527be752ce84509d032a02f399c784eb9a07224d9f7244a33756c7a721",
         intel: "8a4f6c23dc553bb3fc2baa914149c3c7061cc8b562bc3829fa63f048ff606d18"

  url "https://rockdesk.io/download/rockdesk-#{version}-macos-#{arch}.dmg"
  name "RockDesk"
  desc "P2P remote desktop, 1-RTT FUSE mount, CLI and native MCP server via 9-digit ID"
  homepage "https://rockdesk.io/"

  livecheck do
    url "https://rockdesk.io/rockd-latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  app "rockd.app"
  binary "#{appdir}/rockd.app/Contents/MacOS/rds"

  zap trash: [
    "~/.config/rockd",
    "~/Library/Application Support/rockd",
    "~/Library/Preferences/io.rockdesk.rockd.plist",
  ]

  caveats <<~EOS
    RockDesk installs both the GUI app (`rockd.app`) and the `rds` CLI on your PATH.

    Quick start:
      1. Open RockDesk once to start the background daemon and get your 9-digit ID.
      2. Check status:
           rds status
      3. Mount a remote folder (1-RTT FUSE, no extra driver needed):
           rds <9-DIGIT-ID> mount :/srv/app ./app
      4. Wire into Claude Code via built-in MCP:
           claude mcp add rockd -- rds mcp
  EOS
end

