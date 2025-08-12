'use client'
import type { FC } from 'react'
import classNames from '@/utils/classnames'
import useTheme from '@/hooks/use-theme'
import { basePath } from '@/utils/var'
export type LogoStyle = 'default' | 'monochromeWhite'

export const logoPathMap: Record<LogoStyle, string> = {
  default: '/logo/logo.svg',
  monochromeWhite: '/logo/logo-monochrome-white.svg',
}

export type LogoSize = 'large' | 'medium' | 'small'

export const logoSizeMap: Record<LogoSize, string> = {
  large: 'w-20 h-8',
  medium: 'w-16 h-7',
  small: 'w-12 h-5',
}

type AaronOSLogoProps = {
  style?: LogoStyle
  size?: LogoSize
  className?: string
}

const AaronOSLogo: FC<AaronOSLogoProps> = ({
  style = 'default',
  size = 'medium',
  className,
}) => {
  const { theme } = useTheme()
  const themedStyle = (theme === 'dark' && style === 'default') ? 'monochromeWhite' : style

  return (
    <img
      src={`${basePath}${logoPathMap[themedStyle]}`}
      className={classNames('block object-contain', logoSizeMap[size], className)}
      alt='aaronOS logo'
    />
  )
}

export default AaronOSLogo

