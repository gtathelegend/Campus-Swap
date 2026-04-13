import svgPaths from "./svg-1tslyzbcmg";

function Icon() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Icon">
      <svg className="absolute block inset-0 size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Icon">
          <path d="M15 18L9 12L15 6" id="Vector" stroke="var(--stroke-0, #4B3621)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
        </g>
      </svg>
    </div>
  );
}

function Heading() {
  return (
    <div className="h-[24px] relative shrink-0 w-[80.133px]" data-name="Heading 2">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Electronics</p>
      </div>
    </div>
  );
}

function Container() {
  return (
    <div className="bg-white h-[57px] relative shrink-0 w-[375px]" data-name="Container">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-b border-solid inset-0 pointer-events-none" />
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex gap-[12px] items-center pb-px pl-[16px] relative size-full">
        <Icon />
        <Heading />
      </div>
    </div>
  );
}

function Text() {
  return (
    <div className="content-stretch flex h-[11.5px] items-start relative shrink-0 w-full" data-name="Text">
      <p className="font-['Inter:Regular',sans-serif] font-normal leading-[15px] not-italic relative shrink-0 text-[#4b3621] text-[10px] tracking-[0.1172px] whitespace-nowrap">New</p>
    </div>
  );
}

function Container4() {
  return (
    <div className="absolute bg-[#d4af37] content-stretch flex flex-col h-[32px] items-start left-[118.27px] pt-[12.5px] px-[8px] rounded-[16777200px] top-[8px] w-[37.234px]" data-name="Container">
      <Text />
    </div>
  );
}

function Container3() {
  return (
    <div className="bg-[#e8dcc8] h-[128px] relative shrink-0 w-full" data-name="Container">
      <Container4 />
    </div>
  );
}

function Paragraph() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">MacBook Charger</p>
    </div>
  );
}

function Paragraph1() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">$30</p>
    </div>
  );
}

function Container5() {
  return (
    <div className="h-[76px] relative shrink-0 w-full" data-name="Container">
      <div className="content-stretch flex flex-col gap-[4px] items-start pt-[12px] px-[12px] relative size-full">
        <Paragraph />
        <Paragraph1 />
      </div>
    </div>
  );
}

function ProductCard() {
  return (
    <div className="bg-white col-1 justify-self-stretch relative rounded-[20px] row-1 self-stretch shrink-0" data-name="ProductCard">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start p-px relative size-full">
          <Container3 />
          <Container5 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Container6() {
  return <div className="bg-[#e8dcc8] h-[128px] shrink-0 w-full" data-name="Container" />;
}

function Paragraph2() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Wireless Mouse</p>
    </div>
  );
}

function Paragraph3() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">$12</p>
    </div>
  );
}

function Container7() {
  return (
    <div className="h-[76px] relative shrink-0 w-full" data-name="Container">
      <div className="content-stretch flex flex-col gap-[4px] items-start pt-[12px] px-[12px] relative size-full">
        <Paragraph2 />
        <Paragraph3 />
      </div>
    </div>
  );
}

function ProductCard1() {
  return (
    <div className="bg-white col-2 justify-self-stretch relative rounded-[20px] row-1 self-stretch shrink-0" data-name="ProductCard">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start p-px relative size-full">
          <Container6 />
          <Container7 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Text1() {
  return (
    <div className="content-stretch flex h-[11.5px] items-start relative shrink-0 w-full" data-name="Text">
      <p className="font-['Inter:Regular',sans-serif] font-normal leading-[15px] not-italic relative shrink-0 text-[#4b3621] text-[10px] tracking-[0.1172px] whitespace-nowrap">Good</p>
    </div>
  );
}

function Container9() {
  return (
    <div className="absolute bg-[#d4af37] content-stretch flex flex-col h-[32px] items-start left-[113.6px] pt-[12.5px] px-[8px] rounded-[16777200px] top-[8px] w-[41.898px]" data-name="Container">
      <Text1 />
    </div>
  );
}

function Container8() {
  return (
    <div className="bg-[#e8dcc8] h-[128px] relative shrink-0 w-full" data-name="Container">
      <Container9 />
    </div>
  );
}

function Paragraph4() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">USB Hub</p>
    </div>
  );
}

function Paragraph5() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">$18</p>
    </div>
  );
}

function Container10() {
  return (
    <div className="h-[76px] relative shrink-0 w-full" data-name="Container">
      <div className="content-stretch flex flex-col gap-[4px] items-start pt-[12px] px-[12px] relative size-full">
        <Paragraph4 />
        <Paragraph5 />
      </div>
    </div>
  );
}

function ProductCard2() {
  return (
    <div className="bg-white col-1 justify-self-stretch relative rounded-[20px] row-2 self-stretch shrink-0" data-name="ProductCard">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start p-px relative size-full">
          <Container8 />
          <Container10 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Container11() {
  return <div className="bg-[#e8dcc8] h-[128px] shrink-0 w-full" data-name="Container" />;
}

function Paragraph6() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">HDMI Cable</p>
    </div>
  );
}

function Paragraph7() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">$8</p>
    </div>
  );
}

function Container12() {
  return (
    <div className="h-[76px] relative shrink-0 w-full" data-name="Container">
      <div className="content-stretch flex flex-col gap-[4px] items-start pt-[12px] px-[12px] relative size-full">
        <Paragraph6 />
        <Paragraph7 />
      </div>
    </div>
  );
}

function ProductCard3() {
  return (
    <div className="bg-white col-2 justify-self-stretch relative rounded-[20px] row-2 self-stretch shrink-0" data-name="ProductCard">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start p-px relative size-full">
          <Container11 />
          <Container12 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Container13() {
  return <div className="bg-[#e8dcc8] h-[128px] shrink-0 w-full" data-name="Container" />;
}

function Paragraph8() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Keyboard</p>
    </div>
  );
}

function Paragraph9() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">$25</p>
    </div>
  );
}

function Container14() {
  return (
    <div className="h-[76px] relative shrink-0 w-full" data-name="Container">
      <div className="content-stretch flex flex-col gap-[4px] items-start pt-[12px] px-[12px] relative size-full">
        <Paragraph8 />
        <Paragraph9 />
      </div>
    </div>
  );
}

function ProductCard4() {
  return (
    <div className="bg-white col-1 justify-self-stretch relative rounded-[20px] row-3 self-stretch shrink-0" data-name="ProductCard">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start p-px relative size-full">
          <Container13 />
          <Container14 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Text2() {
  return (
    <div className="content-stretch flex h-[11.5px] items-start relative shrink-0 w-full" data-name="Text">
      <p className="font-['Inter:Regular',sans-serif] font-normal leading-[15px] not-italic relative shrink-0 text-[#4b3621] text-[10px] tracking-[0.1172px] whitespace-nowrap">New</p>
    </div>
  );
}

function Container16() {
  return (
    <div className="absolute bg-[#d4af37] content-stretch flex flex-col h-[32px] items-start left-[118.27px] pt-[12.5px] px-[8px] rounded-[16777200px] top-[8px] w-[37.234px]" data-name="Container">
      <Text2 />
    </div>
  );
}

function Container15() {
  return (
    <div className="bg-[#e8dcc8] h-[128px] relative shrink-0 w-full" data-name="Container">
      <Container16 />
    </div>
  );
}

function Paragraph10() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Webcam</p>
    </div>
  );
}

function Paragraph11() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#4b3621] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">$35</p>
    </div>
  );
}

function Container17() {
  return (
    <div className="h-[76px] relative shrink-0 w-full" data-name="Container">
      <div className="content-stretch flex flex-col gap-[4px] items-start pt-[12px] px-[12px] relative size-full">
        <Paragraph10 />
        <Paragraph11 />
      </div>
    </div>
  );
}

function ProductCard5() {
  return (
    <div className="bg-white col-2 justify-self-stretch relative rounded-[20px] row-3 self-stretch shrink-0" data-name="ProductCard">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start p-px relative size-full">
          <Container15 />
          <Container17 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Container2() {
  return (
    <div className="gap-x-[12px] gap-y-[12px] grid grid-cols-[repeat(2,minmax(0,1fr))] grid-rows-[repeat(3,minmax(0,1fr))] h-[642px] relative shrink-0 w-full" data-name="Container">
      <ProductCard />
      <ProductCard1 />
      <ProductCard2 />
      <ProductCard3 />
      <ProductCard4 />
      <ProductCard5 />
    </div>
  );
}

function Container1() {
  return (
    <div className="flex-[1_0_0] min-h-px min-w-px relative w-[375px]" data-name="Container">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[16px] px-[16px] relative size-full">
          <Container2 />
        </div>
      </div>
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

function Container19() {
  return (
    <div className="flex-[1_0_0] min-h-px min-w-px relative rounded-[14px] w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[8px] px-[8px] relative size-full">
        <Icon1 />
      </div>
    </div>
  );
}

function Text3() {
  return (
    <div className="h-[15px] relative shrink-0 w-[28.219px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[15px] left-0 not-italic text-[#7e6d57] text-[10px] top-[0.5px] tracking-[0.1172px] whitespace-nowrap">Home</p>
      </div>
    </div>
  );
}

function Container18() {
  return (
    <div className="h-[55px] relative shrink-0 w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-center relative size-full">
        <Container19 />
        <Text3 />
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
            <path d="M4.45 4.45L0.833333 0.833333" id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
      <div className="absolute inset-[12.5%_20.83%_20.83%_12.5%]" data-name="Vector">
        <div className="absolute inset-[-6.25%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 15 15">
            <path d={svgPaths.p32110270} id="Vector" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Container21() {
  return (
    <div className="bg-[#d4af37] flex-[1_0_0] min-h-px min-w-px relative rounded-[14px] w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[8px] px-[8px] relative size-full">
        <Icon2 />
      </div>
    </div>
  );
}

function Text4() {
  return (
    <div className="h-[15px] relative shrink-0 w-[33.453px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[15px] left-0 not-italic text-[#d4af37] text-[10px] top-[0.5px] tracking-[0.1172px] whitespace-nowrap">Search</p>
      </div>
    </div>
  );
}

function Container20() {
  return (
    <div className="h-[55px] relative shrink-0 w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-center relative size-full">
        <Container21 />
        <Text4 />
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

function Container23() {
  return (
    <div className="flex-[1_0_0] min-h-px min-w-px relative rounded-[14px] w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[8px] px-[8px] relative size-full">
        <Icon3 />
      </div>
    </div>
  );
}

function Text5() {
  return (
    <div className="h-[15px] relative shrink-0 w-[17.617px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[15px] left-0 not-italic text-[#7e6d57] text-[10px] top-[0.5px] tracking-[0.1172px] whitespace-nowrap">Sell</p>
      </div>
    </div>
  );
}

function Container22() {
  return (
    <div className="h-[55px] relative shrink-0 w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-center relative size-full">
        <Container23 />
        <Text5 />
      </div>
    </div>
  );
}

function Icon4() {
  return (
    <div className="h-[20px] overflow-clip relative shrink-0 w-full" data-name="Icon">
      <div className="absolute inset-[8.33%]" data-name="Vector">
        <div className="absolute inset-[-5%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 18.3334 18.3335">
            <path d={svgPaths.p3b994500} id="Vector" stroke="var(--stroke-0, #4B3621)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.66667" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function Container25() {
  return (
    <div className="flex-[1_0_0] min-h-px min-w-px relative rounded-[14px] w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[8px] px-[8px] relative size-full">
        <Icon4 />
      </div>
    </div>
  );
}

function Text6() {
  return (
    <div className="h-[15px] relative shrink-0 w-[22.664px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[15px] left-0 not-italic text-[#7e6d57] text-[10px] top-[0.5px] tracking-[0.1172px] whitespace-nowrap">Chat</p>
      </div>
    </div>
  );
}

function Container24() {
  return (
    <div className="h-[55px] relative shrink-0 w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-center relative size-full">
        <Container25 />
        <Text6 />
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

function Container27() {
  return (
    <div className="flex-[1_0_0] min-h-px min-w-px relative rounded-[14px] w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col items-start pt-[8px] px-[8px] relative size-full">
        <Icon5 />
      </div>
    </div>
  );
}

function Text7() {
  return (
    <div className="h-[15px] relative shrink-0 w-[31.078px]" data-name="Text">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[15px] left-0 not-italic text-[#7e6d57] text-[10px] top-[0.5px] tracking-[0.1172px] whitespace-nowrap">Profile</p>
      </div>
    </div>
  );
}

function Container26() {
  return (
    <div className="h-[55px] relative shrink-0 w-[36px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[4px] items-center relative size-full">
        <Container27 />
        <Text7 />
      </div>
    </div>
  );
}

function BottomNav() {
  return (
    <div className="bg-white h-[80px] relative shrink-0 w-[375px]" data-name="BottomNav">
      <div aria-hidden="true" className="absolute border-[#e8dcc8] border-solid border-t inset-0 pointer-events-none" />
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex items-center justify-between pl-[32.297px] pr-[32.328px] pt-px relative size-full">
        <Container18 />
        <Container20 />
        <Container22 />
        <Container24 />
        <Container26 />
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
        <BottomNav />
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