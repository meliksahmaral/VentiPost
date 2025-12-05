export const dynamic = 'force-dynamic';

import { ReactNode } from 'react';
import Image from 'next/image';
import clsx from 'clsx';
import loadDynamic from 'next/dynamic';
import { isGeneralServerSide } from '@gitroom/helpers/utils/is.general.server.side';

const ReturnUrlComponent = loadDynamic(() => import('./return.url.component'));

export default function AuthLayout({
  children,
}: {
  children: ReactNode;
}) {
  const isGeneral = isGeneralServerSide();

  // Merkezî brand ismi
  const BRAND_NAME =
    process.env.NEXT_PUBLIC_APP_NAME ||
    (isGeneral ? 'Postiz' : 'Gitroom');

  // Logo yolu da env ile override edilebilir
  const BRAND_LOGO =
    process.env.NEXT_PUBLIC_LOGO_URL ||
    (isGeneral ? '/postiz.svg' : '/logo.svg');

  return (
    <div className="dark !bg-black lbox">
      <ReturnUrlComponent />
      <div className="absolute start-0 top-0 z-[0] h-[100vh] w-[100vw] overflow-hidden bg-loginBg bg-contain bg-no-repeat bg-left-top" />
      <div className="relative z-[1] px-3 lg:pr-[100px] xs:mt-[70px] flex justify-center lg:justify-end items-center h-[100vh] w-[100vw] overflow-hidden">
        <div className="w-full max-w-lg h-[614px] flex flex-col bg-loginBox bg-no-repeat bg-contain">
          <div className="w-full relative">
            <div className="custom:fixed custom:text-start custom:left-[20px] custom:justify-start custom:top-[20px] absolute -top-[100px] text-textColor justify-center items-center w-full flex gap-[10px]">
              <Image
                src={BRAND_LOGO}
                width={55}
                height={53}
                alt={`${BRAND_NAME} Logo`}
              />
              <div
                className={clsx(
                  !isGeneral ? 'mt-[12px]' : 'min-w-[80px]'
                )}
              >
                {/* Artık dev Postiz SVG yok, her şey brand ismine bağlı */}
                <div className="text-[40px] leading-none">
                  {BRAND_NAME}
                </div>
              </div>
            </div>
          </div>

          <div className="p-[32px] w-full h-[660px] text-textColor rbox">
            {children}
          </div>

          <div className="flex flex-1 flex-col">
            <div className="flex-1 flex justify-end">
              <div className="absolute top-0 bg-gradient-to-t from-customColor9 w-[1px] translate-x-[22px] h-full" />
            </div>
            <div>
              <div className="absolute end-0 bg-gradient-to-l from-customColor9 h-[1px] translate-y-[60px] w-full" />
            </div>
          </div>

          <div className="absolute top-0 bg-gradient-to-t from-customColor9 w-[1px] -translate-x-[22px] h-full" />
          <div className="absolute end-0 bg-gradient-to-l from-customColor9 h-[1px] -translate-y-[22px] w-full" />
        </div>
      </div>
    </div>
  );
}
