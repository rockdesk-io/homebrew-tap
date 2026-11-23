cask "rockdesk" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.19"
  sha256 arm:   "9b8882b7208c8db9ce5d4eca22c8ef5d275ee1f04f125efc271989cf5e7ad2f9",
         intel: "3881878937e1bdda88e15fa5207801f776964540af6cc7563923236533a3a564"

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

