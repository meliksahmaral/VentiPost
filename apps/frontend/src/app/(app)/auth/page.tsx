import { internalFetch } from '@gitroom/helpers/utils/internal.fetch';
export const dynamic = 'force-dynamic';
import { Register } from '@gitroom/frontend/components/auth/register';
import { Metadata } from 'next';
import { isGeneralServerSide } from '@gitroom/helpers/utils/is.general.server.side';
import Link from 'next/link';
import { getT } from '@gitroom/react/translation/get.translation.service.backend';
import { LoginWithOidc } from '@gitroom/frontend/components/auth/login.with.oidc';

// Brand ismi için tek bir kaynak:
// 1) NEXT_PUBLIC_APP_NAME varsa onu kullan
// 2) Yoksa eski fallback: isGeneralServerSide ? Postiz : Gitroom
const BRAND_NAME =
  process.env.NEXT_PUBLIC_APP_NAME ||
  (isGeneralServerSide() ? 'Postiz' : 'Gitroom');

export const metadata: Metadata = {
  title: `${BRAND_NAME} Register`,
  description: '',
};

type AuthProps = {
  searchParams?: {
    provider?: string;
  };
};

export default async function Auth({ searchParams }: AuthProps) {
  const t = await getT();

  if (process.env.DISABLE_REGISTRATION === 'true') {
    const canRegister = (
      await (await internalFetch('/auth/can-register')).json()
    ).register;

    if (!canRegister && !searchParams?.provider) {
      return (
        <>
          <LoginWithOidc />
          <div className="text-center">
            {t('registration_is_disabled', 'Registration is disabled')}
            <br />
            <Link className="underline hover:font-bold" href="/auth/login">
              {t('login_instead', 'Login instead')}
            </Link>
          </div>
        </>
      );
    }
  }

  return <Register />;
}
