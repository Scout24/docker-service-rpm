Name:		%{name}
Version:	%{version}
Release:	%{release}
Summary:	Docker %{image} as service

Group:		Application/Misc
License:	Proprietary
Source0:	image
Source1:	service.sh

Requires:	%{requires}
BuildArch:	noarch

%description
Docker container as Linux service

%install
mkdir -p %{buildroot}/usr/share/%{name} %{buildroot}/etc/init.d
install -m 0644 %{SOURCE0} %{buildroot}/usr/share/%{name}/image
install -m 0755 %{SOURCE1} %{buildroot}/etc/init.d/%{name}


%files
%defattr(-,root,root,-)
/usr/share/%{name}
/etc/init.d/%{name}

%post
chkconfig --add %{name}
chkconfig %{name} on
if service %{name} status ; then
	service %{name} restart
fi

%preun
if [ $1 == 0 ] ; then
	chkconfig --del %{name}
	service %{name} stop || :
fi
