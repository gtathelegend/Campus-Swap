function Heading() {
  return (
    <div className="h-[30px] relative shrink-0 w-[54.844px]" data-name="Heading 2">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[30px] left-0 not-italic text-[#4b3621] text-[20px] top-0 tracking-[-0.4492px] whitespace-nowrap">Filters</p>
      </div>
    </div>
  );
}

function Text() {
  return (
    <div className="h-[24px] relative shrink-0 w-[41.125px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#7e6d57] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Reset</p>
      </div>
    </div>
  );
}

function Container() {
  return (
    <div className="bg-white h-[63px] relative shrink-0 w-[375px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-b border-solid inset-0 pointer-events-none" />
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex items-center justify-between pb-px px-[16px] relative size-full">
        <Heading />
        <Text />
      </div>
    </div>
  );
}

function Heading1() {
  return (
    <div className="h-[27px] relative shrink-0 w-full" data-name="Heading 3">
      <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[27px] left-0 not-italic text-[#4b3621] text-[18px] top-[0.5px] tracking-[-0.4395px] whitespace-nowrap">Category</p>
    </div>
  );
}

function Text1() {
  return (
    <div className="content-stretch flex h-[19px] items-start relative shrink-0 w-full" data-name="Text">
      <p className="font-['Inter:Regular',sans-serif] font-normal leading-[24px] not-italic relative shrink-0 text-[#4b3621] text-[16px] tracking-[-0.3125px] whitespace-nowrap">Books</p>
    </div>
  );
}

function Container4() {
  return (
    <div className="absolute bg-[#d4af37] content-stretch flex flex-col h-[42px] items-start left-0 pb-px pt-[11.5px] px-[17px] rounded-[16777200px] top-0 w-[78.609px]" data-name="Container">
      <div aria-hidden="true" className="absolute border border-[#d4af37] border-solid inset-0 pointer-events-none rounded-[16777200px]" />
      <Text1 />
    </div>
  );
}

function Text2() {
  return (
    <div className="content-stretch flex h-[19px] items-start relative shrink-0 w-full" data-name="Text">
      <p className="font-['Inter:Regular',sans-serif] font-normal leading-[24px] not-italic relative shrink-0 text-[#4b3621] text-[16px] tracking-[-0.3125px] whitespace-nowrap">Electronics</p>
    </div>
  );
}

function Container5() {
  return (
    <div className="absolute bg-white content-stretch flex flex-col h-[42px] items-start left-[86.61px] pb-px pt-[11.5px] px-[17px] rounded-[16777200px] top-0 w-[114.133px]" data-name="Container">
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[16777200px]" />
      <Text2 />
    </div>
  );
}

function Text3() {
  return (
    <div className="content-stretch flex h-[19px] items-start relative shrink-0 w-full" data-name="Text">
      <p className="font-['Inter:Regular',sans-serif] font-normal leading-[24px] not-italic relative shrink-0 text-[#4b3621] text-[16px] tracking-[-0.3125px] whitespace-nowrap">Fashion</p>
    </div>
  );
}

function Container6() {
  return (
    <div className="absolute bg-white content-stretch flex flex-col h-[42px] items-start left-[208.74px] pb-px pt-[11.5px] px-[17px] rounded-[16777200px] top-0 w-[89.781px]" data-name="Container">
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[16777200px]" />
      <Text3 />
    </div>
  );
}

function Container3() {
  return (
    <div className="h-[42px] relative shrink-0 w-full" data-name="Container">
      <Container4 />
      <Container5 />
      <Container6 />
    </div>
  );
}

function Container2() {
  return (
    <div className="content-stretch flex flex-col gap-[12px] h-[81px] items-start relative shrink-0 w-full" data-name="Container">
      <Heading1 />
      <Container3 />
    </div>
  );
}

function Heading2() {
  return (
    <div className="h-[27px] relative shrink-0 w-full" data-name="Heading 3">
      <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[27px] left-0 not-italic text-[#4b3621] text-[18px] top-[0.5px] tracking-[-0.4395px] whitespace-nowrap">Price Range</p>
    </div>
  );
}

function Container9() {
  return <div className="bg-[#d4af37] h-[8px] rounded-[16777200px] shrink-0 w-full" data-name="Container" />;
}

function Container8() {
  return (
    <div className="bg-[#e8dcc8] h-[8px] relative rounded-[16777200px] shrink-0 w-full" data-name="Container">
      <div className="content-stretch flex flex-col items-start pr-[114.336px] relative size-full">
        <Container9 />
      </div>
    </div>
  );
}

function Text4() {
  return (
    <div className="h-[24px] relative shrink-0 w-[19.531px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#7e6d57] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">$0</p>
      </div>
    </div>
  );
}

function Text5() {
  return (
    <div className="h-[24px] relative shrink-0 w-[36.406px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#7e6d57] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">$100</p>
      </div>
    </div>
  );
}

function Container10() {
  return (
    <div className="content-stretch flex h-[24px] items-start justify-between relative shrink-0 w-full" data-name="Container">
      <Text4 />
      <Text5 />
    </div>
  );
}

function Container7() {
  return (
    <div className="content-stretch flex flex-col gap-[12px] h-[79px] items-start relative shrink-0 w-full" data-name="Container">
      <Heading2 />
      <Container8 />
      <Container10 />
    </div>
  );
}

function Heading3() {
  return (
    <div className="h-[27px] relative shrink-0 w-full" data-name="Heading 3">
      <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[27px] left-0 not-italic text-[#4b3621] text-[18px] top-[0.5px] tracking-[-0.4395px] whitespace-nowrap">Condition</p>
    </div>
  );
}

function Container14() {
  return (
    <div className="relative rounded-[4px] shrink-0 size-[20px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#7e6d57] border-solid inset-0 pointer-events-none rounded-[4px]" />
    </div>
  );
}

function Text6() {
  return (
    <div className="h-[24px] relative shrink-0 w-[32.469px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">New</p>
      </div>
    </div>
  );
}

function Container13() {
  return (
    <div className="bg-white h-[50px] relative rounded-[14px] shrink-0 w-full" data-name="Container">
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[14px]" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center pl-[13px] pr-px py-px relative size-full">
          <Container14 />
          <Text6 />
        </div>
      </div>
    </div>
  );
}

function Container16() {
  return (
    <div className="relative rounded-[4px] shrink-0 size-[20px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#7e6d57] border-solid inset-0 pointer-events-none rounded-[4px]" />
    </div>
  );
}

function Text7() {
  return (
    <div className="h-[24px] relative shrink-0 w-[65.883px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Like New</p>
      </div>
    </div>
  );
}

function Container15() {
  return (
    <div className="bg-white h-[50px] relative rounded-[14px] shrink-0 w-full" data-name="Container">
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[14px]" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center pl-[13px] pr-px py-px relative size-full">
          <Container16 />
          <Text7 />
        </div>
      </div>
    </div>
  );
}

function Container18() {
  return (
    <div className="relative rounded-[4px] shrink-0 size-[20px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#7e6d57] border-solid inset-0 pointer-events-none rounded-[4px]" />
    </div>
  );
}

function Text8() {
  return (
    <div className="h-[24px] relative shrink-0 w-[39.43px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Good</p>
      </div>
    </div>
  );
}

function Container17() {
  return (
    <div className="bg-white h-[50px] relative rounded-[14px] shrink-0 w-full" data-name="Container">
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[14px]" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center pl-[13px] pr-px py-px relative size-full">
          <Container18 />
          <Text8 />
        </div>
      </div>
    </div>
  );
}

function Container20() {
  return (
    <div className="relative rounded-[4px] shrink-0 size-[20px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-2 border-[#7e6d57] border-solid inset-0 pointer-events-none rounded-[4px]" />
    </div>
  );
}

function Text9() {
  return (
    <div className="h-[24px] relative shrink-0 w-[26.234px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Fair</p>
      </div>
    </div>
  );
}

function Container19() {
  return (
    <div className="bg-white h-[50px] relative rounded-[14px] shrink-0 w-full" data-name="Container">
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[14px]" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center pl-[13px] pr-px py-px relative size-full">
          <Container20 />
          <Text9 />
        </div>
      </div>
    </div>
  );
}

function Container12() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] h-[224px] items-start relative shrink-0 w-full" data-name="Container">
      <Container13 />
      <Container15 />
      <Container17 />
      <Container19 />
    </div>
  );
}

function Container11() {
  return (
    <div className="content-stretch flex flex-col gap-[12px] h-[263px] items-start relative shrink-0 w-full" data-name="Container">
      <Heading3 />
      <Container12 />
    </div>
  );
}

function Container1() {
  return (
    <div className="flex-[1_0_0] min-h-px min-w-px relative w-[375px]" data-name="Container">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[24px] items-start pt-[16px] px-[16px] relative size-full">
          <Container2 />
          <Container7 />
          <Container11 />
        </div>
      </div>
    </div>
  );
}

function Button() {
  return (
    <div className="bg-[#d4af37] h-[48px] relative rounded-[16px] shrink-0 w-full" data-name="Button">
      <p className="-translate-x-1/2 absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-[172.1px] not-italic text-[#4b3621] text-[16px] text-center top-[11.5px] tracking-[-0.3125px] whitespace-nowrap">Apply Filters</p>
    </div>
  );
}

function Container21() {
  return (
    <div className="bg-white h-[81px] relative shrink-0 w-[375px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-solid border-t inset-0 pointer-events-none" />
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[17px] px-[16px] relative size-full">
        <Button />
      </div>
    </div>
  );
}

function App() {
  return (
    <div className="bg-[#f7f2e7] flex-[1_0_0] min-h-px min-w-px relative rounded-[32px] shadow-[0px_10px_15px_-3px_rgba(0,0,0,0.1),0px_4px_6px_-4px_rgba(0,0,0,0.1)] w-[375px]" data-name="App">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start overflow-clip relative rounded-[inherit] size-full">
        <Container />
        <Container1 />
        <Container21 />
      </div>
    </div>
  );
}

export default function MobileScreen() {
  return (
    <div className="content-stretch flex flex-col items-start relative size-full" data-name="MobileScreen">
      <App />
    </div>
  );
}