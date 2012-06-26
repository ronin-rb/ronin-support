#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'resolv'

class Resolv

  # List of valid Top-Level-Domains
  TLDS = %w[
    aero arpa asia biz cat com coop edu gov info int jobs mil mobi museum net
    org pro tel travel xxx

    ac ad ae af ag ai al am an ao aq ar as at au aw ax az
    ba bb bd be bf bg bh bi bj bm bn bo br bs bt bv bw by bz
    ca cc cd cf cg ch ci ck cl cm cn co cr cs cu cv cx cy cz
    dd de dj dk dm do dz
    ec ee eg eh er es et eu
    fi fj fk fm fo fr
    ga gb gd ge gf gg gh gi gl gm gn gp gq gr gs gt gu gw gy
    hk hm hn hr ht hu
    id ie il im in io iq ir is it
    je jm jo jp
    ke kg kh ki km kn kp kr kw ky kz
    la lb lc li lk lr ls lt lu lv ly
    ma mc md me mg mh mk ml mm mn mo mp mq mr ms mt mu mv mw mx my mz
    na nc ne nf ng ni nl no np nr nu nz
    om
    pa pe pf pg ph pk pl pm pn pr ps pt pw py
    qa
    re ro rs ru rw
    sa sb sc sd se sg sh si sj sk sl sm sn so sr ss st su sv sy sz
    tc td tf tg th tj tk tl tm tn to tp tr tt tv tw tz
    ua ug ak us uy uz
    va vc ve vg vi vn vu
    wf ws
    ye yt
    za zm zw
  ]

  #
  # Creates a new resolver.
  #
  # @param [String, Array<String>, nil] nameserver
  #   The nameserver(s) to query.
  #
  # @return [Resolv::DNS]
  #   A new resolver for the given nameservers, or the default resolver.
  #
  # @example
  #   Resolv.resolver('4.2.2.1')
  #
  # @since 0.3.0
  #
  # @api public
  #
  def Resolv.resolver(nameserver=nil)
    if nameserver then DNS.new(:nameserver => nameserver)
    else               self
    end
  end

end
