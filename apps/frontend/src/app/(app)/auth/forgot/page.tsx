export const dynamic = 'force-dynamic';

import { Forgot } from '@gitroom/frontend/components/auth/forgot';
import { Metadata } from 'next';
import { isGeneralServerSide } from '@gitroom/helpers/utils/is.general.server.side';

// MERKEZİ BRAND NAME
const BRAND_NAME =
  process.env.NEXT_PUBLIC_APP_NAME ||
  (isGeneralServerSide() ? 'Postiz' : 'Gitroom');

export const metadata: Metadata = {
  title: `${BRAND_NAME} • Forgot Password`,
  description: '',
};

export default async function Auth() {
  return <Forgot />;
}
