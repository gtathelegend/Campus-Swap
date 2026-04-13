import { useState } from "react";
import { useNavigate } from "react-router";
import { Search } from "lucide-react";
import { C, font, conversations } from "../data";
import { BottomNav } from "../components/BottomNav";

export default function Messages() {
  const navigate = useNavigate();
  const [query, setQuery] = useState("");

  const filtered = conversations.filter(
    (c) =>
      c.seller.name.toLowerCase().includes(query.toLowerCase()) ||
      c.lastMessage.toLowerCase().includes(query.toLowerCase())
  );

  return (
    <div className="flex flex-col h-full" style={{ background: C.cream }}>
      {/* Header */}
      <div
        className="flex-shrink-0 flex items-center px-4"
        style={{ background: C.base, height: 63, borderBottom: `1px solid ${C.border}` }}
      >
        <span style={{ fontFamily: font.family, fontSize: 20, fontWeight: 500, color: C.espresso, letterSpacing: "-0.449px" }}>
          Messages
        </span>
      </div>

      {/* Search bar */}
      <div className="flex-shrink-0 mx-4 my-3 flex items-center gap-3 rounded-2xl px-4" style={{ background: C.cream, height: 48 }}>
        <Search size={20} color={C.mocha} strokeWidth={1.7} />
        <input
          type="text"
          placeholder="Search messages..."
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          className="flex-1 outline-none bg-transparent"
          style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}
        />
      </div>

      {/* Chat list */}
      <div className="flex-1 overflow-y-auto" style={{ background: C.base }}>
        {filtered.map((convo) => (
          <button
            key={convo.id}
            onClick={() => navigate(`/chat/${convo.id}`)}
            className="w-full flex items-center gap-3 px-4"
            style={{ height: 85, borderBottom: `1px solid ${C.border}` }}
          >
            {/* Avatar */}
            <div className="rounded-full flex-shrink-0" style={{ width: 48, height: 48, background: C.border }} />

            {/* Text */}
            <div className="flex-1 flex flex-col gap-1 items-start">
              <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
                {convo.seller.name}
              </span>
              <span
                className="w-full text-left overflow-hidden whitespace-nowrap"
                style={{
                  fontFamily: font.family, fontSize: 16, color: C.mocha,
                  letterSpacing: "-0.3125px", textOverflow: "ellipsis", maxWidth: "100%",
                }}
              >
                {convo.lastMessage}
              </span>
            </div>
          </button>
        ))}
      </div>

      <BottomNav active="chat" />
    </div>
  );
}
