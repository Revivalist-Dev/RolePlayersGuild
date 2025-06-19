<%@ Page Title="" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.My_Stories.Edit_Post.Default" %>
<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register TagPrefix="uc1" TagName="UserNav" Src="~/templates/controls/UserNav.ascx" %>
<%@ Register TagPrefix="uc1" TagName="SendAsChanger" Src="~/templates/controls/SendAsChanger.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" CurrentParent="Stories" />
    <div runat="server" id="divThreadAd">
        <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
        <!-- ThreadsAd -->
        <ins class="adsbygoogle"
             style="display: block"
             data-ad-client="ca-pub-1247828126747788"
             data-ad-slot="7028871313"
             data-ad-format="auto"></ins>
        <script>
            (adsbygoogle = window.adsbygoogle || []).push({});
        </script>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <script>
        function deactivateButton(theBtn) {
            $(theBtn).addClass("disabled");
            $(theBtn).prop('value', "Please Wait...");
            $(theBtn).prop("disabled", true);
            //$(theBtn).hide();
        };
        function Closepopups() {
            $('#MyCharacters').modal('hide');
        }
    </script>
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <div class="FullWidthPostSection" runat="server" id="divSubmitPostSection">
        <div class="MakePost clearfix">
            <div class="col-xs-2 col-xl-1 PostAsImage">
                <uc1:SendAsChanger runat="server" ID="SendAsChanger" />
            </div>
            <div class="col-xs-10 col-xl-11 PostText">
                <asp:TextBox ID="txtPostContent" runat="server" TextMode="MultiLine" CssClass="form-control" Rows="10" placeholder="Please make sure OOC posts are properly labeled." required ValidateRequestMode="Disabled" TabIndex="20"></asp:TextBox>
            </div>
        </div>
        <div class="ButtonPanel clearfix">
            <div class="col-xl-3 col-sm-4 col-xs-12">
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12">
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                <asp:LinkButton ID="btnSubmitPost" runat="server" Text="<span class='glyphicon glyphicon-plus'></span>&nbsp;Submit Post" OnClick="btnSubmitPost_Click" CssClass="btn btn-success" OnClientClick="__doPostBack;deactivateButton(this);" UseSubmitBehavior="false" TabIndex="21" />
            </div>
        </div>
    </div>
</asp:Content>
