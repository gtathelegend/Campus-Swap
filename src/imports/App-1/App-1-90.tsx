function Heading() {
  return (
    <div className="h-[36px] relative shrink-0 w-full" data-name="Heading 1">
      <p className="absolute font-['Inter:Medium',sans-serif] font-medium leading-[36px] left-0 not-italic text-[#4b3621] text-[24px] top-0 tracking-[0.0703px] whitespace-nowrap">Welcome Back</p>
    </div>
  );
}

function Paragraph() {
  return (
    <div className="h-[24px] relative shrink-0 w-full" data-name="Paragraph">
      <p className="absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-0 not-italic text-[#7e6d57] text-[16px] top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">Login to your account</p>
    </div>
  );
}

function Container() {
  return (
    <div className="h-[68px] relative shrink-0 w-[327px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[8px] items-start relative size-full">
        <Heading />
        <Paragraph />
      </div>
    </div>
  );
}

function InputField() {
  return (
    <div className="bg-white h-[50px] relative rounded-[16px] shrink-0 w-full" data-name="InputField">
      <div className="flex flex-row items-center overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex items-center px-[16px] py-[12px] relative size-full">
          <p className="font-['Inter:Regular',sans-serif] font-normal leading-[normal] not-italic relative shrink-0 text-[#9b8b7e] text-[16px] tracking-[-0.3125px] whitespace-nowrap">Email</p>
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[16px]" />
    </div>
  );
}

function InputField1() {
  return (
    <div className="bg-white h-[50px] relative rounded-[16px] shrink-0 w-full" data-name="InputField">
      <div className="flex flex-row items-center overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex items-center px-[16px] py-[12px] relative size-full">
          <p className="font-['Inter:Regular',sans-serif] font-normal leading-[normal] not-italic relative shrink-0 text-[#9b8b7e] text-[16px] tracking-[-0.3125px] whitespace-nowrap">Password</p>
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[#e8dcc8] border-solid inset-0 pointer-events-none rounded-[16px]" />
    </div>
  );
}

function Container1() {
  return (
    <div className="h-[116px] relative shrink-0 w-[327px]" data-name="Container">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid content-stretch flex flex-col gap-[16px] items-start relative size-full">
        <InputField />
        <InputField1 />
      </div>
    </div>
  );
}

function Button() {
  return (
    <div className="bg-[#d4af37] h-[48px] relative rounded-[16px] shrink-0 w-[327px]" data-name="Button">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="-translate-x-1/2 absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-[164.19px] not-italic text-[#4b3621] text-[16px] text-center top-[11.5px] tracking-[-0.3125px] whitespace-nowrap">Login</p>
      </div>
    </div>
  );
}

function Text() {
  return (
    <div className="absolute content-stretch flex h-[19px] items-start left-[222px] top-[-1px] w-[54.648px]" data-name="Text">
      <p className="font-['Inter:Regular',sans-serif] font-normal leading-[24px] not-italic relative shrink-0 text-[#d4af37] text-[16px] text-center tracking-[-0.3125px] whitespace-nowrap">Sign up</p>
    </div>
  );
}

function Paragraph1() {
  return (
    <div className="h-[24px] relative shrink-0 w-[327px]" data-name="Paragraph">
      <div className="bg-clip-padding border-0 border-[transparent] border-solid relative size-full">
        <p className="-translate-x-1/2 absolute font-['Inter:Regular',sans-serif] font-normal leading-[24px] left-[136.55px] not-italic text-[#7e6d57] text-[16px] text-center top-[-0.5px] tracking-[-0.3125px] whitespace-nowrap">{`Don't have an account?`}</p>
        <Text />
      </div>
    </div>
  );
}

export default function App() {
  return (
    <div className="bg-[#f7f2e7] content-stretch flex flex-col gap-[24px] items-start justify-center overflow-clip pl-[24px] relative rounded-[32px] shadow-[0px_10px_15px_-3px_rgba(0,0,0,0.1),0px_4px_6px_-4px_rgba(0,0,0,0.1)] size-full" data-name="App">
      <Container />
      <Container1 />
      <Button />
      <Paragraph1 />
    </div>
  );
}