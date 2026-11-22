import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function disableBash(pi: ExtensionAPI) {
  pi.on("before_agent_start", async () => {
    const tools = pi.getActiveTools().filter((name) => name !== "bash");
    pi.setActiveTools(tools);
  });
}
