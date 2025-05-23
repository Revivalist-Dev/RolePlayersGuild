<%@ Page Title="Chat Room on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.ChatRooms.Room.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>
<%@ Register Src="~/templates/controls/ChatRoom.ascx" TagPrefix="uc1" TagName="ChatRoom" %>
<%@ Register Src="~/templates/controls/CharacterListing.ascx" TagPrefix="uc1" TagName="CharacterListing" %>



<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <script>
        $(document).ready(function () {
            checkSize();
            $(window).resize(checkSize);
        });

        //Function to the css rule
        function checkSize() {
            if ($(".col-sm-3").css("float") != "left") {
                if ($(".SideBarCharacterList").html().trim() != "") {
                    $("#BottomOfPageCharacterList").html($(".SideBarCharacterList").html());
                    $(".SideBarCharacterList").empty();
                }
            }
            else {
                if ($("#BottomOfPageCharacterList").html().trim() != "") {
                    $(".SideBarCharacterList").html($("#BottomOfPageCharacterList").html());
                    $("#BottomOfPageCharacterList").empty();
                }
            }
        }
    </script>
    <uc1:UserNav runat="server" ID="UserNav" />

    <div class="SideBarCharacterList">
        <uc1:CharacterListing runat="server" ID="CharacterListing2" ScreenStatus="NewCharacters" RecordCount="12" DisplaySize="2-Col" />
    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">

    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <uc1:ChatRoom runat="server" ID="ucChatRoom" />

    <div id="BottomOfPageCharacterList">
    </div>
</asp:Content>
