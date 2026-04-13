import { useState } from "react";
import { useNavigate, useParams } from "react-router";
import { ChevronLeft, MoreVertical, Send } from "lucide-react";
import { C, font, conversations } from "../data";

export default function Chat() {
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();
  const [text, setText] = useState("");
  const [extraMessages, setExtraMessages] = useState<Array<{ id: string; from: "me"; text: string; time: string }>>([]);

  const convo = conversations.find((c) => c.id === id) ?? conversations[0];
  const allMessages = [...convo.messages, ...extraMessages];

  const sendMessage = () => {
    if (!text.trim()) return;
    setExtraMessages((prev) => [
      ...prev,
      { id: String(Date.now()), from: "me", text: text.trim(), time: "Now" },
    ]);
    setText("");
  };

  return (
    <div className="flex flex-col h-full" style={{ background: C.cream }}>
      {/* Header */}
      <div
        className="flex-shrink-0 flex items-center gap-3 px-4"
        style={{ background: C.base, height: 81, borderBottom: `1px solid ${C.border}` }}
      >
        <button onClick={() => navigate(-1)}>
          <ChevronLeft size={24} color={C.espresso} strokeWidth={2} />
        </button>
        <div className="rounded-full" style={{ width: 40, height: 40, background: C.border, flexShrink: 0 }} />
        <div className="flex-1 flex flex-col items-start">
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
            {convo.seller.name}
          </span>
          <span style={{ fontFamily: font.family, fontSize: 16, color: C.mocha, letterSpacing: "-0.3125px" }}>
            Active now
          </span>
        </div>
        <button>
          <MoreVertical size={24} color={C.espresso} strokeWidth={2} />
        </button>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-4 flex flex-col gap-4">
        {allMessages.map((msg) => (
          <div
            key={msg.id}
            className={`flex items-start gap-2 ${msg.from === "me" ? "flex-row-reverse" : "flex-row"}`}
          >
            {msg.from === "them" && (
              <div className="rounded-full flex-shrink-0" style={{ width: 32, height: 32, background: C.border }} />
            )}
            <div
              className="flex items-center px-4 py-3 rounded-[20px]"
              style={{
                maxWidth: "72%",
                background: msg.from === "me" ? C.gold : C.base,
                border: msg.from === "them" ? `1px solid ${C.border}` : "none",
                borderTopLeftRadius: msg.from === "them" ? 0 : 20,
                borderTopRightRadius: msg.from === "me" ? 0 : 20,
              }}
            >
              <p style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, lineHeight: "24px", letterSpacing: "-0.3125px" }}>
                {msg.text}
              </p>
            </div>
          </div>
        ))}
      </div>

      {/* Message input */}
      <div
        className="flex-shrink-0 flex items-center gap-3 px-4 pt-4 pb-5"
        style={{ background: C.base, borderTop: `1px solid ${C.border}` }}
      >
        <div
          className="flex-1 flex items-center rounded-[20px] px-4"
          style={{ background: C.cream, height: 48 }}
        >
          <input
            type="text"
            placeholder="Type a message..."
            value={text}
            onChange={(e) => setText(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && sendMessage()}
            className="flex-1 outline-none bg-transparent"
            style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}
          />
        </div>
        <button
          onClick={sendMessage}
          className="flex items-center justify-center rounded-full flex-shrink-0"
          style={{ width: 48, height: 48, background: C.gold }}
        >
          <Send size={20} color={C.base} strokeWidth={1.7} />
        </button>
      </div>
    </div>
  );
}
