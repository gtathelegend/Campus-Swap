import svgPaths from "./svg-jc4ebh9xms";

function Heading() {
  return (
    <div className="h-[30px] relative shrink-0 w-[91.172px]" data-name="Heading 2">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[30px] left-0 not-italic text-[#4b3621] text-[20px] top-0 tracking-[-0.4492px] whitespace-nowrap">Messages</p>
      </div>
    </div>
  );
}

function TopBar() {
  return (
    <div className="absolute bg-white content-stretch flex h-[63px] items-center justify-between left-0 pb-px pl-[16px] pr-[267.828px] top-0 w-[375px]" data-name="TopBar">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-b border-solid inset-0 pointer-events-none" />
      <Heading />
    </div>
  );
}

function Icon() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="Icon">
      <svg className="absolute block inset-0 size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g id="Icon">
          <path d={svgPaths.p13ab3b10} id="Vector" stroke="var(--stroke-0, #7E6D57)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          <path d={svgPaths.pcddfd00} id="Vector_2" stroke="var(--stroke-0, #7E6D57)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
        </g>
      </svg>
    </div>
  );
}

function Text() {
  return (
    <div className="h-[24px] relative shrink-0 w-[141.266px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#9b8b7e] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Search messages...</p>
      </div>
    </div>
  );
}

function SearchBar() {
  return (
    <div className="absolute bg-[#f7f2e7] content-stretch flex gap-[12px] h-[48px] items-center left-[16px] pl-[16px] rounded-[16px] top-[79px] w-[343px]" data-name="SearchBar">
      <Icon />
      <Text />
    </div>
  );
}

function Container1() {
  return <div className="bg-[#e8dcc8] rounded-[16777200px] shrink-0 size-[48px]" data-name="Container" />;
}

function Paragraph() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Sarah Johnson</p>
    </div>
  );
}

function Paragraph1() {
  return (
    <div className="h-[24px] overflow-clip relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#7e6d57] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Is the textbook still available?</p>
    </div>
  );
}

function Container2() {
  return (
    <div className="flex-[1_0_0] h-[52px] min-h-px min-w-px relative" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-start relative size-full">
        <Paragraph />
        <Paragraph1 />
      </div>
    </div>
  );
}

function ChatPreview() {
  return (
    <div className="h-[85px] relative shrink-0 w-full" data-name="ChatPreview">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-b border-solid inset-0 pointer-events-none" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center pb-px px-[16px] relative size-full">
          <Container1 />
          <Container2 />
        </div>
      </div>
    </div>
  );
}

function Container3() {
  return <div className="bg-[#e8dcc8] rounded-[16777200px] shrink-0 size-[48px]" data-name="Container" />;
}

function Paragraph2() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Mike Chen</p>
    </div>
  );
}

function Paragraph3() {
  return (
    <div className="h-[24px] overflow-clip relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#7e6d57] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Can we meet tomorrow?</p>
    </div>
  );
}

function Container4() {
  return (
    <div className="flex-[1_0_0] h-[52px] min-h-px min-w-px relative" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-start relative size-full">
        <Paragraph2 />
        <Paragraph3 />
      </div>
    </div>
  );
}

function ChatPreview1() {
  return (
    <div className="h-[85px] relative shrink-0 w-full" data-name="ChatPreview">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-b border-solid inset-0 pointer-events-none" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center pb-px px-[16px] relative size-full">
          <Container3 />
          <Container4 />
        </div>
      </div>
    </div>
  );
}

function Container5() {
  return <div className="bg-[#e8dcc8] rounded-[16777200px] shrink-0 size-[48px]" data-name="Container" />;
}

function Paragraph4() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Emma Davis</p>
    </div>
  );
}

function Paragraph5() {
  return (
    <div className="h-[24px] overflow-clip relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#7e6d57] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Thanks for the quick response!</p>
    </div>
  );
}

function Container6() {
  return (
    <div className="flex-[1_0_0] h-[52px] min-h-px min-w-px relative" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-start relative size-full">
        <Paragraph4 />
        <Paragraph5 />
      </div>
    </div>
  );
}

function ChatPreview2() {
  return (
    <div className="h-[85px] relative shrink-0 w-full" data-name="ChatPreview">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-b border-solid inset-0 pointer-events-none" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center pb-px px-[16px] relative size-full">
          <Container5 />
          <Container6 />
        </div>
      </div>
    </div>
  );
}

function Container7() {
  return <div className="bg-[#e8dcc8] rounded-[16777200px] shrink-0 size-[48px]" data-name="Container" />;
}

function Paragraph6() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Alex Turner</p>
    </div>
  );
}

function Paragraph7() {
  return (
    <div className="h-[24px] overflow-clip relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#7e6d57] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">{`I'm interested in the desk lamp`}</p>
    </div>
  );
}

function Container8() {
  return (
    <div className="flex-[1_0_0] h-[52px] min-h-px min-w-px relative" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-start relative size-full">
        <Paragraph6 />
        <Paragraph7 />
      </div>
    </div>
  );
}

function ChatPreview3() {
  return (
    <div className="h-[85px] relative shrink-0 w-full" data-name="ChatPreview">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-b border-solid inset-0 pointer-events-none" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center pb-px px-[16px] relative size-full">
          <Container7 />
          <Container8 />
        </div>
      </div>
    </div>
  );
}

function Container9() {
  return <div className="bg-[#e8dcc8] rounded-[16777200px] shrink-0 size-[48px]" data-name="Container" />;
}

function Paragraph8() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Lisa Park</p>
    </div>
  );
}

function Paragraph9() {
  return (
    <div className="h-[24px] overflow-clip relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#7e6d57] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">{`What's the condition?`}</p>
    </div>
  );
}

function Container10() {
  return (
    <div className="flex-[1_0_0] h-[52px] min-h-px min-w-px relative" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-start relative size-full">
        <Paragraph8 />
        <Paragraph9 />
      </div>
    </div>
  );
}

function ChatPreview4() {
  return (
    <div className="h-[85px] relative shrink-0 w-full" data-name="ChatPreview">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-b border-solid inset-0 pointer-events-none" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center pb-px px-[16px] relative size-full">
          <Container9 />
          <Container10 />
        </div>
      </div>
    </div>
  );
}

function Container() {
  return (
    <div className="absolute bg-white content-stretch flex flex-col h-[589px] items-start left-0 overflow-clip top-[143px] w-[375px]" data-name="Container">
      <ChatPreview />
      <ChatPreview1 />
      <ChatPreview2 />
      <ChatPreview3 />
      <ChatPreview4 />
    </div>
  );
}

function Icon1() {
  return (
    <div className="h-[20px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute bottom-[12.5%] left-[37.5%] right-[37.5%] top-1/2" data-name="Vector">
        <div className="absolute inset-[-11.11%_-16.67%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 6.66667 9.16667">
            <path d={svgPaths.p12f93600} id="Vector" stroke="var(--stroke-0, #4B3621)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
      <div className="absolute inset-[8.34%_12.5%_12.5%_12.5%]" data-name="Vector">
        <div className="absolute inset-[-5.26%_-5.56%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16.6667 17.4996">
            <path d={svgPaths.p29aa3400} id="Vector" stroke="var(--stroke-0, #4B3621)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Container12() {
  return (
    <div className="flex-[1_0_0] min-h-px min-w-px relative rounded-[14px] w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[8px] px-[8px] relative size-full">
        <Icon1 />
      </div>
    </div>
  );
}

function Text1() {
  return (
    <div className="h-[15px] relative shrink-0 w-[28.219px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[15px] left-0 not-italic text-[#7e6d57] text-[10px] top-[0.5px] tracking-[0.1172px] whitespace-nowrap">Home</p>
      </div>
    </div>
  );
}

function Container11() {
  return (
    <div className="h-[55px] relative shrink-0 w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-center relative size-full">
        <Container12 />
        <Text1 />
      </div>
    </div>
  );
}

function Icon2() {
  return (
    <div className="h-[20px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute inset-[69.42%_12.5%_12.5%_69.42%]" data-name="Vector">
        <div className="absolute inset-[-23.04%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 5.28333 5.28333">
            <path d="M4.45 4.45L0.833333 0.833333" id="Vector" stroke="var(--stroke-0, #4B3621)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
      <div className="absolute inset-[12.5%_20.83%_20.83%_12.5%]" data-name="Vector">
        <div className="absolute inset-[-6.25%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 15 15">
            <path d={svgPaths.p32110270} id="Vector" stroke="var(--stroke-0, #4B3621)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Container14() {
  return (
    <div className="flex-[1_0_0] min-h-px min-w-px relative rounded-[14px] w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[8px] px-[8px] relative size-full">
        <Icon2 />
      </div>
    </div>
  );
}

function Text2() {
  return (
    <div className="h-[15px] relative shrink-0 w-[33.453px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[15px] left-0 not-italic text-[#7e6d57] text-[10px] top-[0.5px] tracking-[0.1172px] whitespace-nowrap">Search</p>
      </div>
    </div>
  );
}

function Container13() {
  return (
    <div className="h-[55px] relative shrink-0 w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-center relative size-full">
        <Container14 />
        <Text2 />
      </div>
    </div>
  );
}

function Icon3() {
  return (
    <div className="h-[20px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute bottom-1/2 left-[20.83%] right-[20.83%] top-1/2" data-name="Vector">
        <div className="absolute inset-[-0.83px_-7.14%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 13.3333 1.66667">
            <path d="M0.833333 0.833333H12.5" id="Vector" stroke="var(--stroke-0, #4B3621)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
      <div className="absolute bottom-[20.83%] left-1/2 right-1/2 top-[20.83%]" data-name="Vector">
        <div className="absolute inset-[-7.14%_-0.83px]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 1.66667 13.3333">
            <path d="M0.833333 0.833333V12.5" id="Vector" stroke="var(--stroke-0, #4B3621)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Container16() {
  return (
    <div className="flex-[1_0_0] min-h-px min-w-px relative rounded-[14px] w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[8px] px-[8px] relative size-full">
        <Icon3 />
      </div>
    </div>
  );
}

function Text3() {
  return (
    <div className="h-[15px] relative shrink-0 w-[17.617px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[15px] left-0 not-italic text-[#7e6d57] text-[10px] top-[0.5px] tracking-[0.1172px] whitespace-nowrap">Sell</p>
      </div>
    </div>
  );
}

function Container15() {
  return (
    <div className="h-[55px] relative shrink-0 w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-center relative size-full">
        <Container16 />
        <Text3 />
      </div>
    </div>
  );
}

function Icon4() {
  return (
    <div className="h-[20px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute inset-[8.34%_8.33%_8.33%_8.33%]" data-name="Vector">
        <div className="absolute inset-[-5%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 18.3334 18.3335">
            <path d={svgPaths.p3b994500} id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Container18() {
  return (
    <div className="bg-[#d4af37] flex-[1_0_0] min-h-px min-w-px relative rounded-[14px] w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[8px] px-[8px] relative size-full">
        <Icon4 />
      </div>
    </div>
  );
}

function Text4() {
  return (
    <div className="h-[15px] relative shrink-0 w-[22.664px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[15px] left-0 not-italic text-[#d4af37] text-[10px] top-[0.5px] tracking-[0.1172px] whitespace-nowrap">Chat</p>
      </div>
    </div>
  );
}

function Container17() {
  return (
    <div className="h-[55px] relative shrink-0 w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-center relative size-full">
        <Container18 />
        <Text4 />
      </div>
    </div>
  );
}

function Icon5() {
  return (
    <div className="h-[20px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute inset-[62.5%_20.83%_12.5%_20.83%]" data-name="Vector">
        <div className="absolute inset-[-16.67%_-7.14%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 13.3333 6.66667">
            <path d={svgPaths.p6877e0} id="Vector" stroke="var(--stroke-0, #4B3621)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
      <div className="absolute inset-[12.5%_33.33%_54.17%_33.33%]" data-name="Vector">
        <div className="absolute inset-[-12.5%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 8.33333 8.33333">
            <path d={svgPaths.p3ffa2780} id="Vector" stroke="var(--stroke-0, #4B3621)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Container20() {
  return (
    <div className="flex-[1_0_0] min-h-px min-w-px relative rounded-[14px] w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[8px] px-[8px] relative size-full">
        <Icon5 />
      </div>
    </div>
  );
}

function Text5() {
  return (
    <div className="h-[15px] relative shrink-0 w-[31.078px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[15px] left-0 not-italic text-[#7e6d57] text-[10px] top-[0.5px] tracking-[0.1172px] whitespace-nowrap">Profile</p>
      </div>
    </div>
  );
}

function Container19() {
  return (
    <div className="h-[55px] relative shrink-0 w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-center relative size-full">
        <Container20 />
        <Text5 />
      </div>
    </div>
  );
}

function BottomNav() {
  return (
    <div className="absolute bg-white content-stretch flex h-[80px] items-center justify-between left-[-5px] pl-[32.297px] pr-[32.328px] pt-px top-[732px] w-[375px]" data-name="BottomNav">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-solid border-t inset-0 pointer-events-none" />
      <Container11 />
      <Container13 />
      <Container15 />
      <Container17 />
      <Container19 />
    </div>
  );
}

export default function App() {
  return (
    <div className="bg-[#f7f2e7] overflow-clip relative rounded-[32px] shadow-[0px_10px_15px_-3px_rgba(0,0,0,0.1),0px_4px_6px_-4px_rgba(0,0,0,0.1)] size-full" data-name="App">
      <TopBar />
      <SearchBar />
      <Container />
      <BottomNav />
    </div>
  );
}